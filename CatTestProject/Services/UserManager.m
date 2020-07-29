//
//  UserManager.m
//  CatTestProject
//
//  Created by Антон Потапчик on 7/29/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "UserManager.h"

@interface UserManager ()

@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *isActive;

@end

@implementation UserManager

- (void)registerUser:(NSString *)login password:(NSString *)password apiKey:(NSString *)apiKey isActive:(NSString *)isActive {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Users"]) {
        NSMutableArray *users = [[[NSUserDefaults standardUserDefaults]objectForKey:@"Users"] mutableCopy];
        NSDictionary *user = @{@"Login": login, @"Password":password, @"ApiKey":apiKey, @"IsActive": isActive};
        [users addObject:user];
        [[NSUserDefaults standardUserDefaults] setObject:users forKey:@"Users"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSDictionary *user = @{@"Login": login, @"Password":password, @"ApiKey":apiKey, @"IsActive": isActive};
        NSArray *users = [NSArray arrayWithObject:user];
        [[NSUserDefaults standardUserDefaults] setObject:users forKey:@"Users"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (BOOL)checkUserRegistration:(NSString *)inputLogin inputPassword:(NSString *)inputPassword {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Users"]) {
        NSMutableArray *users = [[[NSUserDefaults standardUserDefaults]objectForKey:@"Users"] mutableCopy];
        for (int i = 0; i < users.count; i++) {
            NSDictionary *user = users[i];
            self.login = user[@"Login"];
            self.password = user[@"Password"];
            if ([inputLogin isEqualToString:self.login] && [inputPassword isEqualToString:self.password]) {
                NSMutableDictionary *mutableUser = [user mutableCopy];
                mutableUser[@"IsActive"] = @"YES";
                [users replaceObjectAtIndex:i withObject:mutableUser];
                [[NSUserDefaults standardUserDefaults] setObject:users forKey:@"Users"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                return YES;
                break;
            }
        }
    }
    return NO;
}

- (BOOL)checkUserLogins:(NSString *)inputLogin {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Users"]) {
        NSMutableArray *users = [[[NSUserDefaults standardUserDefaults]objectForKey:@"Users"] mutableCopy];
        for (NSDictionary *user in users) {
            self.login = user[@"Login"];
            if ([inputLogin isEqualToString:self.login]) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)checkUserStatus {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Users"]) {
        NSMutableArray *users = [[[NSUserDefaults standardUserDefaults]objectForKey:@"Users"] mutableCopy];
        for (NSDictionary *user in users) {
            self.isActive = user[@"IsActive"];
            if ([self.isActive isEqualToString:@"YES"]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)editUserInfo:(NSString *)login password:(NSString *)password apiKey:(NSString *)apiKey {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Users"]) {
        NSMutableArray *users = [[[NSUserDefaults standardUserDefaults]objectForKey:@"Users"] mutableCopy];
        for (int i = 0; i < users.count; i ++) {
            NSMutableDictionary *mutableUser = [users[i] mutableCopy];
            self.isActive = mutableUser[@"IsActive"];
            if ([self.isActive isEqualToString:@"YES"]) {
                mutableUser[@"Login"] = login;
                mutableUser[@"Password"] = password;
                mutableUser[@"ApiKey"] = apiKey;
                [users replaceObjectAtIndex:i withObject:mutableUser];
                [[NSUserDefaults standardUserDefaults] setObject:users forKey:@"Users"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
            }
        }
    }
}

- (NSDictionary *)updateUserInfo {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Users"]) {
        NSMutableArray *users = [[[NSUserDefaults standardUserDefaults]objectForKey:@"Users"] mutableCopy];
        for (NSDictionary *user in users) {
            self.isActive = user[@"IsActive"];
            if ([self.isActive isEqualToString:@"YES"]) {
                return user;
                break;
            }
        }
    }
    return nil;
}

- (void)logout {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Users"]) {
        NSMutableArray *users = [[[NSUserDefaults standardUserDefaults]objectForKey:@"Users"] mutableCopy];
        for (int i = 0; i < users.count; i ++) {
            NSMutableDictionary *mutableUser = [users[i] mutableCopy];
            self.isActive = mutableUser[@"IsActive"];
            if ([self.isActive isEqualToString:@"YES"]) {
                mutableUser[@"IsActive"] = @"NO";
                [users replaceObjectAtIndex:i withObject:mutableUser];
                [[NSUserDefaults standardUserDefaults] setObject:users forKey:@"Users"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
            }
        }
    }
}





@end
