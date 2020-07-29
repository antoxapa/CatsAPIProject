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
#import "LoginViewDelegate.h"
#import "LikedViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainPresenter : NSObject <UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property BOOL isLoaded;

//- (instancetype)initWithNetworkManager:(NetworkManager *)networkManager;

+ (instancetype)sharedInstance;
- (void)initNetworkManager;


- (void)registerCellsFor:(UICollectionView *)collectionView;

- (void)setViewDelegate:(id<CatViewDelegate>)view;
- (void)setLikedViewDelegate:(id<LikedViewDelegate>)view;
- (void)setLoginViewDelegate:(id<LoginViewDelegate>)view;

- (void)setAuthViewDelegate:(id<AuthenticationViewDelegate>)view;
- (void)setApiViewDelegate:(id<EnterApiViewDelegate>)view;
- (void)setRegistrationViewDelegate:(id<RegistrationViewDelegate>)view;

- (void)setDetailViewDelegate:(id<DetailViewDelegate>)view;

- (void)downloadCats;
- (void)downloadImage:(NSString *)url;
- (void)cancelDownloadingImage:(NSIndexPath *)indexPath;
- (void)startLoadingImages;

- (void)pushDetailVC:(NSIndexPath *)indexPath;
- (void)pushMainVC;
- (void)pushRegistrationVC;
- (void)pushRegisteredMainVC;
- (void)pushRegisteredUser:(NSString *)login password:(NSString *)password apiKey:(NSString *)apiKey registered:(BOOL)registered;
- (void)showApiWebPage;
- (void)pressNextButton;
- (void)showAlreadyExistAlert;
- (void)changeProfileValues;
- (void)showWrongDataAlert;


- (void)updateScreenWithData;
- (void)changeValues:(NSString *)login password:(NSString *)password apiKey:(NSString *)apiKey and:(NSMutableArray *)users;
- (void)isUserReadyForUpload;
- (void)showAlertOne;
- (void)uploadImage:(UIImage *)image andPath:(NSString *)fileName;


- (void)showViewController:(UIViewController *)viewController;
- (void)dismisViewController:(UIViewController *) viewController;

- (void)showAlert;
- (void)gridButtonTapped;

@end

NS_ASSUME_NONNULL_END
