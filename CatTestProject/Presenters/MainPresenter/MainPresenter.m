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
#import "LoginViewDelegate.h"
#import "LikedViewDelegate.h"
#import "ShowDismissProtocol.h"
#import "Photos/Photos.h"
#import "DetailViewController.h"

@interface MainPresenter () 

@property (nonatomic, weak)  id<CatViewDelegate> catView;

@property (nonatomic, strong) id<DetailViewDelegate> detailVC;

@property (nonatomic, strong) NetworkManager *networkManager;
@property (nonatomic, strong) NSMutableArray<CatModel *> *catsArray;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic) int numberOfItems;

@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *apiKey;
@property BOOL registered;

@property BOOL gridTapped;

@end

@implementation MainPresenter

- (void)initNetworkManager {
    JSONParser *parser = [[JSONParser alloc]init];
    _networkManager = [[NetworkManager alloc]initWithParser:parser];
}

#pragma mark:- Delegates

-(void)setViewDelegate:(id<CatViewDelegate>)view {
    self.catView = view;
}

-(void)setDetailViewDelegate:(id<DetailViewDelegate>)view {
    self.detailVC = view;
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
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.catView showAlertController:[NSString stringWithFormat:@"%@", error]];
            });
        }
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
    [self.detailVC.saveButton setHidden:NO];
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
    CatCell *cell = [self.catView.collectionView cellForItemAtIndexPath:indexPath];
    DetailViewController *dvc = [[DetailViewController alloc]initWithImage:cell.catImageView.image andURL:cell.catImageURL];
    dvc.presenter = self;
    [self.catView presentDetailViewController:dvc];
}

- (void)saveImageInGallery:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}
- (void)presentSaveAlertController {
    [self.detailVC showSavedStatusAlert];
}

@end
