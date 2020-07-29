//
//  LoginViewPresenter.h
//  CatTestProject
//
//  Created by Антон Потапчик on 7/29/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewPresenter : NSObject

- (instancetype)initWithUser;
- (void)setLoginViewDelegate:(id<LoginViewDelegate>)view;
- (NSDictionary *)checkUserActivityStatus;
- (void)changeValues:(NSString *)login password:(NSString *)password apiKey:(NSString *)apiKey;
- (void)changeProfileValues;
- (void)logout;
@end

NS_ASSUME_NONNULL_END
