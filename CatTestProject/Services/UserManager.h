//
//  UserManager.h
//  CatTestProject
//
//  Created by Антон Потапчик on 7/29/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserManager : NSObject

- (void)registerUser:(NSString *)login password:(NSString *)password apiKey:(NSString *)apiKey isActive:(NSString *)isActive;
- (BOOL)checkUserRegistration:(NSString *)inputLogin inputPassword:(NSString *)inputPassword;
- (BOOL)checkUserLogins:(NSString *)inputLogin;
- (BOOL)checkUserStatus;

- (void)editUserInfo:(NSString *)login password:(NSString *)password apiKey:(NSString *)apiKey;
- (NSDictionary *)updateUserInfo;
- (void)logout;
@end

NS_ASSUME_NONNULL_END
