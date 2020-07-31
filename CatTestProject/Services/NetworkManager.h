//
//  NetworkManager.h
//  CatTestProject
//
//  Created by Антон Потапчик on 7/24/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JSONParser.h"
#import "CatModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSCache *cache;
- (instancetype)initWithParser:(JSONParser *)parser;

- (void)getCachedImageWithURL:(NSString *)stringURL completion:(void(^)(NSString *, UIImage *, NSError *))completion;
- (void)cancelDownloadingForUrl:(NSString *)url;
- (void)uploadImage:(NSString *)apiKey fileName:(NSString *)fileName image:(UIImage *)image completion:(void (^)(NSData *, NSURLResponse *response, NSError *error))completion;

- (void)loadCats:(NSString *)urlString completion:(void (^)(NSData *, NSError *))completion;
- (void)parseData:(NSString *)url completion:(void (^)(NSMutableArray<CatModel *> *, NSError *))completion;
- (void)loadImageForURL:(NSString *)url completion:(void (^)(NSData *, NSURLResponse *response, NSError *error))completion;
- (void)parseUloadedData:(NSString *)url apiKey:(NSString *)apiKey completion:(void (^)(NSMutableArray<CatModel *> *, NSError *))completion;


@end

NS_ASSUME_NONNULL_END
