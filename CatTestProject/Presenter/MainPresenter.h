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
#import "AuthenticationViewDelegate.h"
#import "EnterApiViewDelegate.h"
#import "RegistrationViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainPresenter : NSObject <UICollectionViewDataSource>

@property BOOL isLoaded;

- (instancetype)initWithNetworkManager:(NetworkManager *)networkManager;
- (void)registerCellsFor:(UICollectionView *)collectionView;
- (void)setViewDelegate:(id<CatViewDelegate>)view;
- (void)setDetailViewDelegate:(id<DetailViewDelegate>)view;
- (void)setAuthViewDelegate:(id<AuthenticationViewDelegate>)view;
- (void)setApiViewDelegate:(id<EnterApiViewDelegate>)view;
-(void)setRegistrationViewDelegate:(id<RegistrationViewDelegate>)view;

- (void)downloadCats;
- (void)downloadImage:(NSString *)url;
- (void)cancelDownloadingImage:(NSIndexPath *)indexPath;
- (void)startLoadingImages;

- (void)pushDetailVC:(NSIndexPath *)indexPath;
- (void)pushMainVC;
- (void)pushRegistrationVC;
- (void)pushRegisteredMainVC;
- (void)pushRegisteredUser;
- (void)showApiWebPage;
- (void)pressNextButton;

- (void)gridButtonTapped;

@end

NS_ASSUME_NONNULL_END
