//
//  MainPresenter.m
//  CatTestProject
//
//  Created by Антон Потапчик on 7/24/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainPresenter.h"
#import "MainViewController.h"
#import "CatModel.h"
#import "CatViewDelegate.h"
#import "CatCell.h"
#import "DetailViewDelegate.h"
#import "AuthenticationViewDelegate.h"
#import "EnterApiViewDelegate.h"
#import "RegistrationViewDelegate.h"

@interface MainPresenter () 

@property (nonatomic, weak)  id<CatViewDelegate> catView;
@property (nonatomic, weak)  id<AuthenticationViewDelegate> authView;
@property (nonatomic, weak)  id<EnterApiViewDelegate> apiView;
@property (nonatomic, weak)  id<RegistrationViewDelegate> registrationView;
@property (nonatomic, strong) id<DetailViewDelegate> detailVC;


@property (nonatomic, strong) NetworkManager *networkManager;
@property (nonatomic, strong) NSMutableArray<CatModel *> *catsArray;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic) int numberOfItems;
@property BOOL gridTapped;

@end

@implementation MainPresenter

-(instancetype)initWithNetworkManager:(NetworkManager *)networkManager {
    self = [super init];
    if (self) {
        _networkManager = networkManager;
        _gridTapped = NO;
        _isLoaded = NO;
    }
    return self;
}

#pragma mark:- Delegates

-(void)setViewDelegate:(id<CatViewDelegate>)view {
    self.catView = view;
}

-(void)setDetailViewDelegate:(id<DetailViewDelegate>)view {
    self.detailVC = view;
}

-(void)setAuthViewDelegate:(id<AuthenticationViewDelegate>)view {
    self.authView = view;
}

-(void)setApiViewDelegate:(id<EnterApiViewDelegate>)view {
    self.apiView = view;
}
-(void)setRegistrationViewDelegate:(id<RegistrationViewDelegate>)view {
    self.registrationView = view;
}


-(void)registerCellsFor:(UICollectionView *)collectionView {
    [collectionView registerClass:[CatCell class] forCellWithReuseIdentifier:@"Cell"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
}

#pragma mark:- UICollectionViewDataSource

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.catImageURL = self.catsArray[indexPath.row].url;
    __weak typeof(self)weakSelf = self;
    [self.networkManager getCachedImageWithURL:self.catsArray[indexPath.row].url completion:^(NSString *url, UIImage * image, NSError * error) {
        if (error) {
            NSLog(@"%@", error);
        }
        if (image) {
            if ([weakSelf.catsArray[indexPath.row].url isEqualToString:cell.catImageURL]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.catImageView.image = image;
                });
            }
        }
    }];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
    
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [footer addSubview:self.indicator];
    self.indicator.color = UIColor.whiteColor;
    self.indicator.frame = CGRectMake(0, 0, 30, 30);
    
    self.indicator.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.indicator.centerXAnchor constraintEqualToAnchor:footer.centerXAnchor],
        [self.indicator.centerYAnchor constraintEqualToAnchor:footer.centerYAnchor],
    ]];
    [self.indicator setUserInteractionEnabled:NO];
    return footer;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.catsArray.count;
}

#pragma mark:-Downloading
-(void)downloadCats {
    __weak typeof (self)weakSelf = self;
    [self.networkManager loadCats:^(NSMutableArray<CatModel *> * array, NSError * error) {
        weakSelf.catsArray = array;
        [weakSelf.catView showCats:array];
    }];
}

- (void)startLoadingImages {
    if (!self.isLoaded) {
        [self.indicator setHidden:NO];
        [self.indicator startAnimating];
        self.isLoaded = YES;
        __weak typeof(self)weakSelf = self;
        [self.networkManager loadCats:^(NSMutableArray<CatModel *> * array, NSError * error) {
            NSMutableArray *cats = array;
            [weakSelf.catView addMoreImages:cats];
        }];
    }
}
- (void)downloadImage:(NSString *)url {
    __weak typeof(self) weakSelf = self;
    [self.networkManager getCachedImageWithURL:url completion:^(NSString * url, UIImage * image, NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.detailVC.imageView.image = image;
        });
    }];
}

- (void)cancelDownloadingImage:(NSIndexPath*)indexPath {
    [self.networkManager cancelDownloadingForUrl:self.catsArray[indexPath.row].url];
}

-(void)gridButtonTapped {
    if (self.catView.numberOfItems == 1) {
        self.catView.numberOfItems = 3;
        self.gridTapped = true;
    } else {
        self.gridTapped = NO;
        self.catView.numberOfItems = 1;
    }
    [self.catView.collectionView.collectionViewLayout invalidateLayout];
}


- (void)pushDetailVC:(NSIndexPath *)indexPath {
    
//    CatCell *cell = [self.catView.collectionView cellForItemAtIndexPath:indexPath];
//    DetailViewController *dvc = [[DetailViewController alloc]initWithImage:cell.catImageView.image andURL:cell.catImageURL];
//    dvc.presenter = self;
//    [self.catView presentDetailViewController:dvc];
}

#pragma mark:- AuthenticationViewDelegate methods

- (void)pushRegisteredUser {
    [self.authView pushRegisteredUser];
}

- (void)pushMainVC {
    [self.authView pushMainVC];
}

- (void)pushRegistrationVC {
    [self.authView pushRegistrationVC];
}

#pragma mark:- RegistrationViewDelegate methods

- (void)pressNextButton {
    [self.registrationView presentEnterAPIVC];
}

#pragma mark:- EnterApiViewDelegate methods
- (void)pushRegisteredMainVC {
    [self.apiView pushMainVC];
}
- (void)showApiWebPage {
    [self.apiView showAPIWebPage];
}




@end
