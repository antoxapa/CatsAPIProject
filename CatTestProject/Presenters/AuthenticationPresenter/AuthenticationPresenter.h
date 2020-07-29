//
//  AuthenticationPresenter.h
//  CatTestProject
//
//  Created by Антон Потапчик on 7/29/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthenticationViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AuthenticationPresenter : NSObject

- (instancetype)initWithUser;
- (void)checkUser:(NSString *)login password:(NSString *)password;
- (void)setAuthViewDelegate:(id<AuthenticationViewDelegate>)view;
- (void)showMainVCWithoutRegistration;
- (void)showRegistrationViewController;
- (BOOL)autoAuthenticateUser;

@end

NS_ASSUME_NONNULL_END
