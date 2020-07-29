//
//  RegistrationViewDelegate.h
//  CatTestProject
//
//  Created by Антон Потапчик on 7/28/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RegistrationViewDelegate <NSObject>

- (void)presentEnterAPIVC;
- (void)showAlreadyExistAlert;

@end

NS_ASSUME_NONNULL_END
