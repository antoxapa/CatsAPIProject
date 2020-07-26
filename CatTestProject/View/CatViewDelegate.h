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
- (void)showCats:(NSArray<CatModel *>*)array;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

NS_ASSUME_NONNULL_END
