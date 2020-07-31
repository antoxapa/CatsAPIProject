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
#import "CatCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainPresenter : NSObject

@property BOOL isLoaded;
- (void)initNetworkManager;
- (void)registerCellsFor:(UICollectionView *)collectionView;
- (void)setViewDelegate:(id<CatViewDelegate>)view;
- (void)setDetailViewDelegate:(id<DetailViewDelegate>)view;
- (void)downloadCats;
- (void)downloadImage:(NSString *)url;
- (void)cancelDownloadingImage:(NSIndexPath *)indexPath;
- (void)startLoadingImages;
- (void)pushDetailVC:(NSIndexPath *)indexPath;
- (void)saveImageInGallery:(UIImage *)image;
- (void)presentSaveAlertController;
- (void)downloadImageForCell:(CatCell *)cell andIndexPath:(NSIndexPath *)indexPath;
- (void)gridButtonTapped;

@end

NS_ASSUME_NONNULL_END
