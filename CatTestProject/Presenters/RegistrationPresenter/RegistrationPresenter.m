//
//  RegistrationPresenter.m
//  CatTestProject
//
//  Created by Антон Потапчик on 7/29/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "RegistrationPresenter.h"
#import "UserManager.h"

@interface RegistrationPresenter ()
@property (nonatomic, strong)  UserManager *userManager;
@property (nonatomic, weak)  id<RegistrationViewDelegate> registrationView;
@end

@implementation RegistrationPresenter

- (instancetype) initWithUser {
    self = [super init];
    if (self) {
        _userManager = [[UserManager alloc]init];
    }
    return self;
}

- (void)setRegistrationViewDelegate:(id<RegistrationViewDelegate>)view {
    self.registrationView = view;
}

- (void)checkUserCurrentLogin:(NSString *)login {
    BOOL user = [self.userManager checkUserLogins:login];
    if (user) {
        [self.registrationView showAlreadyExistAlert];
    } else {
        [self.registrationView presentEnterAPIVC];
    }
}

#pragma mark:- RegistrationViewDelegate methods

//- (void)pressNextButton {
//    [self.registrationView presentEnterAPIVC];
//}
//- (void)showAlreadyExistAlert {
//    [self.registrationView showAlreadyExistAlert];
//}

@end
