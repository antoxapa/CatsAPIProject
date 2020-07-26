//
//  DownloadImageOperation.h
//  CatTestProject
//
//  Created by Антон Потапчик on 7/26/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownloadImageOperation : NSOperation
@property (nonatomic, copy) void(^completion)(NSData *, NSURLResponse *);

- (instancetype)initWithUrl:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
