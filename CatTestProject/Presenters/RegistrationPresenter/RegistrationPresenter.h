//
//  RegistrationPresenter.h
//  CatTestProject
//
//  Created by Антон Потапчик on 7/29/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegistrationViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegistrationPresenter : NSObject
- (instancetype) initWithUser;
- (void)setRegistrationViewDelegate:(id<RegistrationViewDelegate>)view;
- (void)checkUserCurrentLogin:(NSString *)login;
@end

NS_ASSUME_NONNULL_END
