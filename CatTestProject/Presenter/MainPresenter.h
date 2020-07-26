//
//  MainPresenter.h
//  CatTestProject
//
//  Created by Антон Потапчик on 7/24/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#import "CatViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainPresenter : NSObject <UICollectionViewDataSource, UICollectionViewDelegate>


-(void)registerCellsFor:(UICollectionView *)collectionView;
-(instancetype)initWithNetworkManager:(NetworkManager *)networkManager;
-(void)setViewDelegate:(id<CatViewDelegate>)view;
-(void)downloadCats;

@end

NS_ASSUME_NONNULL_END
