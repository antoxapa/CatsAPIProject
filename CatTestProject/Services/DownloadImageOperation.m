//
//  DownloadImageOperation.m
//  CatTestProject
//
//  Created by Антон Потапчик on 7/26/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "DownloadImageOperation.h"

@interface DownloadImageOperation ()

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSURLSessionDataTask *dataTask;

@end

@implementation DownloadImageOperation

- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

- (void)main {
    __weak typeof(self) weakSelf = self;
    if (self.isCancelled) { return; }
    
    NSURL *url = [NSURL URLWithString:self.url];
    self.dataTask = [[NSURLSession sharedSession]
                     dataTaskWithURL:url
                     completionHandler:^(NSData *data,
                                         NSURLResponse *response,
                                         NSError * error) {
        if (weakSelf.isCancelled) { return; }
        if (!data) { return; }
        if (self.completion) {
            self.completion(data, response);
        }
    }];
    
    if (self.isCancelled) { return; }
    [self.dataTask resume];
}
- (void)cancel {
    [self.dataTask cancel];
    [super cancel];
}

@end
