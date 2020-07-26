//
//  MainViewController.h
//  CatTestProject
//
//  Created by Антон Потапчик on 7/24/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainViewController : UIViewController <CatViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

NS_ASSUME_NONNULL_END