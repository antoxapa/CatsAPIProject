//
//  LikedViewDelegate.h
//  CatTestProject
//
//  Created by Антон Потапчик on 7/29/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CatModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LikedViewDelegate <NSObject>

- (void)showAlertController;
- (void)showErrorAlert:(NSString *)error;
- (void)checkUserRegistered;

- (void)startIndicatorAnimating;
- (void)stopIndicatorAnimating;

- (void)showCats:(NSMutableArray<CatModel *>*)array;
- (void)startIndicator;
- (void)addMoreImages:(NSMutableArray<CatModel *>*)array;
- (void)showAuthErrorAlert;


@end

NS_ASSUME_NONNULL_END
