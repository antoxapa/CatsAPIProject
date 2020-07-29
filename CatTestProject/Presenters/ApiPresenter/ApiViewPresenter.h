//
//  ApiViewPresenter.h
//  CatTestProject
//
//  Created by Антон Потапчик on 7/29/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnterApiViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface ApiViewPresenter : NSObject
-(void)setApiViewDelegate:(id<EnterApiViewDelegate>)view;
- (instancetype) initWithUser;
- (void)showApiWebPage;
- (void)registerUserAndPushMainVC:(NSString *)login password:(NSString *)password apiKey:(NSString *)apiKey isActive:(NSString *)isActive;

@end

NS_ASSUME_NONNULL_END
