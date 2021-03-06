//
//  NetworkManager.m
//  CatTestProject
//
//  Created by Антон Потапчик on 7/24/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "CatModel.h"
#import "JSONParser.h"
#import "DownloadImageOperation.h"


@interface NetworkManager ()


@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) JSONParser *parser;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSArray<NSOperation *> *> *operations;

@end

@implementation NetworkManager

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration];
    }
    return _session;
}

- (instancetype)initWithParser:(JSONParser *)parser {
    self = [super init];
    if (self) {
        _parser = parser;
        _queue = [[NSOperationQueue alloc] init];
        _operations = [NSMutableDictionary new];
        _cache = [[NSCache alloc]init];
    }
    return self;
}

- (void)loadCats:(NSString *)urlString completion:(void (^)(NSData *, NSError *))completion {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url
                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        completion(data, nil);
    }];
    [dataTask resume];
}

- (void)loadUploadedCats:(NSString *)urlString apiKey:(NSString *)apiKey completion:(void (^)(NSData *, NSError *))completion {
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSDictionary *headers = @{ @"x-api-key": apiKey };
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        NSString *someString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", someString);
        if ([someString containsString:@"AUTHENTICATION_ERROR"]) {
            completion(nil,nil);
            return;
        }
        if (error) {
            NSLog(@"%@", error);
            completion(nil,error);
        } else {
            completion(data, nil);
        }
    }];
    [dataTask resume];
}

- (void)parseUloadedData:(NSString *)url apiKey:(NSString *)apiKey completion:(void (^)(NSMutableArray<CatModel *> *, NSError *))completion {
    [self loadUploadedCats:url apiKey:apiKey completion:^(NSData *data, NSError *error) {
        if (data) {
            [self.parser parseCats:data completion:completion];
        } else {
            completion(nil, error);
        }
    }];
}

- (void)parseData:(NSString *)url completion:(void (^)(NSMutableArray<CatModel *> *, NSError *))completion {
    
    [self loadCats:url completion:^(NSData *data, NSError *error) {
        if (data) {
            [self.parser parseCats:data completion:completion];
        } else {
            completion(nil, error);
        }
    }];
}


-(void)getCachedImageWithURL:(NSString *)stringURL completion:(void(^)(NSString *, UIImage *, NSError *))completion {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *image = [self.cache objectForKey:stringURL];
        if (image) {
            completion(stringURL, image, nil);
        } else {
            UIImage *placeholder = [UIImage imageNamed:@"cat"];
            completion(nil, placeholder, nil);
            [weakSelf loadImageForURL:stringURL completion:^(NSData * data, NSURLResponse * response, NSError * error) {
                if (error) {
                    completion(nil, nil,error);
                    return;
                }
                UIImage *image = [UIImage imageWithData:data];
                [weakSelf.cache setObject:image forKey:stringURL];
                completion(stringURL ,image, nil);
            }];
        }
    });
}

- (void)loadImageForURL:(NSString *)url completion:(void (^)(NSData *, NSURLResponse *response, NSError *error))completion {
    
    [self cancelDownloadingForUrl:url];
    DownloadImageOperation *operation = [[DownloadImageOperation alloc] initWithUrl:url];
    self.operations[url] = @[operation];
    operation.completion = ^(NSData *data, NSURLResponse *response) {
        completion(data, response, nil);
    };
    [self.queue addOperation:operation];
}

- (void)uploadImage:(NSString *)apiKey fileName:(NSString *)fileName image:(UIImage *)image completion:(void (^)(NSData *, NSURLResponse *response, NSError *error))completion {
    
    NSString *boundary = [NSString stringWithFormat:@"Boundary-%@", NSUUID.UUID.UUIDString];
    NSDictionary *headers = @{ @"content-type": [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary],
                               @"x-api-key": apiKey };
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.thecatapi.com/v1/images/upload"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    
    NSMutableData *httpBody = [NSMutableData new];
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary]dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", fileName]dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: image/%@\r\n\r\n", [fileName componentsSeparatedByString:@"."].lastObject]dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:UIImageJPEGRepresentation(image, 0.7)];
    [httpBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary]dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPBody = httpBody;
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil,nil,error);
        } else {
            completion(data,nil, nil);
        }
    }];
    [dataTask resume];
}

- (void)cancelDownloadingForUrl:(NSString *)url {
    NSArray<NSOperation *> *operations = self.operations[url];
    if (!operations) { return; }
    for (NSOperation *operation in operations) {
        [operation cancel];
    }
}

@end
