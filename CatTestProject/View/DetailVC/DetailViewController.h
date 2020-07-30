//
//  DetailViewController.h
//  CatTestProject
//
//  Created by Антон Потапчик on 7/28/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainPresenter.h"
#import "DetailViewDelegate.h"

@interface DetailViewController : UIViewController <DetailViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) MainPresenter *presenter;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UIButton *saveButton;

@end

