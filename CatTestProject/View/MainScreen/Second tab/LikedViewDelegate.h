//
//  LikedViewDelegate.h
//  CatTestProject
//
//  Created by Антон Потапчик on 7/29/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LikedViewDelegate <NSObject>

- (void)showAlertController;
- (void)showErrorAlert:(NSString *)error;
- (void)checkUserRegistered;
- (void)stopIndicatorAnimating;


@end

NS_ASSUME_NONNULL_END
