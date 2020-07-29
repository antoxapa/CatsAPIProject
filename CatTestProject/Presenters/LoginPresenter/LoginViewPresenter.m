//
//  LoginViewPresenter.m
//  CatTestProject
//
//  Created by Антон Потапчик on 7/29/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "LoginViewPresenter.h"
#import "LoginViewDelegate.h"
#import "UserManager.h"

@interface LoginViewPresenter ()
@property (nonatomic, weak)  id<LoginViewDelegate> loginVew;
@property (nonatomic, strong) UserManager *userManager;
@end

@implementation LoginViewPresenter

- (instancetype)initWithUser {
    self = [super init];
    if (self) {
        _userManager = [[UserManager alloc]init];
    }
    return self;
}

-(void)setLoginViewDelegate:(id<LoginViewDelegate>)view {
    self.loginVew = view;
}

#pragma mark:- LoginViewDelegate methods

- (NSDictionary *)checkUserActivityStatus {
    BOOL active = [self.userManager checkUserStatus];
    if (!active) {
        [self.loginVew showAlertController];
        return nil;
    } else {
        NSDictionary *userDictionary = [self.userManager updateUserInfo];
        return userDictionary;
    }
}
- (void)changeProfileValues {
    [self.loginVew changeProfileValues];
}

- (void)changeValues:(NSString *)login password:(NSString *)password apiKey:(NSString *)apiKey {
    [self.userManager editUserInfo:login password:password apiKey:apiKey];
}

- (void)logout {
    [self.userManager logout];
}

@end
