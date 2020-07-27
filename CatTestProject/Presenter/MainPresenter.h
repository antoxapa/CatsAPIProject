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

@interface MainPresenter : NSObject <UICollectionViewDataSource>

- (instancetype)initWithNetworkManager:(NetworkManager *)networkManager;
- (void)registerCellsFor:(UICollectionView *)collectionView;
- (void)setViewDelegate:(id<CatViewDelegate>)view;

- (void)downloadCats;
- (void)cancelDownloadingImage:(NSIndexPath *)indexPath;
- (void)startLoadingImages;

- (void)gridButtonTapped;

@end

NS_ASSUME_NONNULL_END
