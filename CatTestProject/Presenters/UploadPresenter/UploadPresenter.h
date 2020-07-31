//
//  UploadPresenter.h
//  CatTestProject
//
//  Created by Антон Потапчик on 7/30/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LikedViewDelegate.h"
#import "ShowDismissProtocol.h"
#import "CatCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface UploadPresenter : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property BOOL isLoaded;
- (instancetype)initWithUser;
- (void)setLikedViewDelegate:(id<LikedViewDelegate, ShowDismissProtocol>)view;
- (void)checkUserRegistered;
- (void)registerCellsFor:(UICollectionView *)collectionView;
- (void)showViewController:(UIViewController *) viewController;
- (void)startIndicatorAnimating;
- (void)downloadImageForCell:(CatCell *)cell andIndexPath:(NSIndexPath *)indexPath;
- (void)getUploadedImagesArray;
- (void)startLoadingImages;
@end

NS_ASSUME_NONNULL_END
