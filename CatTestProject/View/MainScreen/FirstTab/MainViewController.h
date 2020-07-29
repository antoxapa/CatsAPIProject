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

@interface MainViewController : UIViewController <CatViewDelegate, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic) int numberOfItems;
@property (nonatomic) BOOL registeredUser;

- (void)addMoreImages:(NSMutableArray<CatModel *>*)array;
@end

NS_ASSUME_NONNULL_END
