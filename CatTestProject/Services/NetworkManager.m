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

@property (nonatomic, strong) NSCache *cache;
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

- (void)loadCats:(void (^)(NSMutableArray<CatModel *> *, NSError *))completion {
    //    NSString *stringURL = [NSString stringWithFormat:@"https://api.thecatapi.com/v1/images/search?limit="];
    NSURL *url = [NSURL URLWithString:@"https://api.thecatapi.com/v1/images/search?limit=21"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    //    NSDictionary *headers = @{ @"x-api-key": @"028b8907-c580-4675-9246-2af353e9e81e"};
    //    [request setAllHTTPHeaderFields:headers];
    
    __weak typeof(self)weakSelf = self;
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        [weakSelf.parser parseCats:data completion:(completion)];
    }];
    
    [dataTask resume];
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

- (void)cancelDownloadingForUrl:(NSString *)url {
    NSArray<NSOperation *> *operations = self.operations[url];
    if (!operations) { return; }
    for (NSOperation *operation in operations) {
        [operation cancel];
    }
}

@end
