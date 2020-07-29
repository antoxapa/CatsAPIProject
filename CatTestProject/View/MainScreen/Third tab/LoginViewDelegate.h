//
//  LoginViewDelegate.h
//  CatTestProject
//
//  Created by Антон Потапчик on 7/28/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LoginViewDelegate <NSObject>

- (void)showAlertController;
- (void)changeProfileValues;
- (void)checkUser:(NSString *)login password:(NSString *)password apiKey:(NSString *)apiKey registered:(BOOL)registered;

@end

NS_ASSUME_NONNULL_END
