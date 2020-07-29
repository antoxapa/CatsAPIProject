//
//  AuthenticationPresenter.m
//  CatTestProject
//
//  Created by Антон Потапчик on 7/29/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "AuthenticationPresenter.h"
#import "UserManager.h"

@interface AuthenticationPresenter ()
@property (nonatomic, weak) id<AuthenticationViewDelegate> authView;
@property (nonatomic, strong)  UserManager *userManager;
@end

@implementation AuthenticationPresenter

- (instancetype) initWithUser {
    self = [super init];
    if (self) {
        _userManager = [[UserManager alloc]init];
    }
    return self;
}

-(void)setAuthViewDelegate:(id<AuthenticationViewDelegate>)view {
    self.authView = view;
}

- (void)checkUser:(NSString *)login password:(NSString *)password {
    BOOL user = [self.userManager checkUserRegistration:login inputPassword:password];
    if (user) {
        [self.authView pushRegisteredUser];
    } else {
        [self.authView showWrongLoginOrPassword];
    }
}

#pragma mark:- AuthenticationViewDelegate methods

- (void)showMainVCWithoutRegistration {
    [self.authView showUnregisteredMainController];
}

- (void)showRegistrationViewController {
    [self.authView pushRegistrationVC];
}

- (BOOL)autoAuthenticateUser {
    return [self.userManager checkUserStatus];
}



@end
