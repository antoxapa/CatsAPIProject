//
//  ShowDismissProtocol.h
//  CatTestProject
//
//  Created by Антон Потапчик on 7/29/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ShowDismissProtocol <NSObject>

- (void)presentVC:(UIViewController *)controller;
- (void)dismisVC:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
