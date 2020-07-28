//
//  EnterApiKeyVC.h
//  CatTestProject
//
//  Created by Антон Потапчик on 7/28/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainPresenter.h"
#import "EnterApiViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnterApiKeyVC : UIViewController <EnterApiViewDelegate>

@property (nonatomic, strong) MainPresenter *presenter;
@property (nonatomic, strong) NSString *loginString;
@property (nonatomic, strong) NSString *passwordString;

@end

NS_ASSUME_NONNULL_END
