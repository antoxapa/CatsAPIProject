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
#import "DetailViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainPresenter : NSObject <UICollectionViewDataSource>

- (instancetype)initWithNetworkManager:(NetworkManager *)networkManager;
- (void)registerCellsFor:(UICollectionView *)collectionView;
- (void)setViewDelegate:(id<CatViewDelegate>)view;
-(void)setDetailViewDelegate:(id<DetailViewDelegate>)view;

- (void)downloadCats;
- (void)downloadImage:(NSString *)url;
- (void)cancelDownloadingImage:(NSIndexPath *)indexPath;
- (void)startLoadingImages;
- (void)pushDetailVC:(NSIndexPath *)indexPath;

- (void)gridButtonTapped;

@end

NS_ASSUME_NONNULL_END
