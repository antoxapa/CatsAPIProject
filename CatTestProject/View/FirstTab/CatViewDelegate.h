//
//  CatViewDelegate.h
//  CatTestProject
//
//  Created by Антон Потапчик on 7/24/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CatModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CatViewDelegate <NSObject>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic) int numberOfItems;

- (void)showCats:(NSMutableArray<CatModel *>*)array;
- (void)addMoreImages:(NSMutableArray<CatModel *>*)array;

@end

NS_ASSUME_NONNULL_END
