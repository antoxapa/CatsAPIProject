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

- (instancetype)initWithParser:(JSONParser *)parser;
- (void)loadCats:(void (^)(NSArray<CatModel *> *, NSError *))completion;
- (void)getCachedImageWithURL:(NSString *)stringURL completion:(void(^)(NSString *, UIImage *, NSError *))completion;
- (void)cancelDownloadingForUrl:(NSString *)url;


@end

NS_ASSUME_NONNULL_END
