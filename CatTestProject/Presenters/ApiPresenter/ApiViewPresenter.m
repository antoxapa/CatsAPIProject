//
//  ApiViewPresenter.m
//  CatTestProject
//
//  Created by Антон Потапчик on 7/29/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "ApiViewPresenter.h"
#import "EnterApiViewDelegate.h"
#import "UserManager.h"

@interface ApiViewPresenter ()

@property (nonatomic, strong)  UserManager *userManager;
@property (nonatomic, weak)  id<EnterApiViewDelegate> apiView;

@end

@implementation ApiViewPresenter

- (instancetype) initWithUser {
    self = [super init];
    if (self) {
        _userManager = [[UserManager alloc]init];
    }
    return self;
}

-(void)setApiViewDelegate:(id<EnterApiViewDelegate>)view {
    self.apiView = view;
}

#pragma mark:- EnterApiViewDelegate methods
- (void)registerUserAndPushMainVC:(NSString *)login password:(NSString *)password apiKey:(NSString *)apiKey isActive:(NSString *)isActive {
    [self.userManager registerUser:login password:password apiKey:apiKey isActive:isActive];
    [self.apiView pushMainVC];
}

- (void)showApiWebPage {
    [self.apiView showAPIWebPage];
}

@end
