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


@interface MainPresenter () 

@property (nonatomic, strong) NetworkManager *networkManager;
@property (nonatomic, weak)  id<CatViewDelegate> catView;
@property (nonatomic, strong) CatModel *model;
@property (nonatomic, copy) NSArray<CatModel *> *catsArray;

@end

@implementation MainPresenter

-(instancetype)initWithNetworkManager:(NetworkManager *)networkManager {
    self = [super init];
    if (self) {
        _networkManager = networkManager;
    }
    return self;
}

-(void)downloadCats {
    [self.networkManager loadCats:^(NSArray<CatModel *> * array, NSError * error) {
        self.catsArray = array;
        [self.catView showCats:array];
    }];
}
-(void)loadImages {
    for (CatModel *item in self.catsArray) {
        [self.networkManager getCachedImageWithURL:item.url completion:^(NSString *url, UIImage * image, NSError * error) {
            
        }];
    }
}

-(void)setViewDelegate:(id<CatViewDelegate>)view {
    self.catView = view;
}

-(void)registerCellsFor:(UICollectionView *)collectionView {
    [collectionView registerClass:[CatCell class] forCellWithReuseIdentifier:@"Cell"];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.catImageURL = self.catsArray[indexPath.row].url;
    [self.networkManager getCachedImageWithURL:self.catsArray[indexPath.row].url completion:^(NSString *url, UIImage * image, NSError * error) {
        if (error) {
            
        }
        if (image) {
            if ([self.catsArray[indexPath.row].url isEqualToString:cell.catImageURL]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.catImageView.image = image;
                });
            }
        }
    }];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { 
    return self.catsArray.count;
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.networkManager cancelDownloadingForUrl:self.catsArray[indexPath.row].url];
}

@end
