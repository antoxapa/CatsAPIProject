//
//  MainViewController.m
//  CatTestProject
//
//  Created by Антон Потапчик on 7/24/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "MainViewController.h"
#import "MainPresenter.h"
#import "NetworkManager.h"
#import "JSONParser.h"

@interface MainViewController () 

@property (nonatomic, strong) MainPresenter *presenter;
@property (nonatomic, copy) NSArray<CatModel *> *catsArray;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JSONParser *parser = [[JSONParser alloc]init];
    self.presenter = [[MainPresenter alloc] initWithNetworkManager:[[NetworkManager alloc] initWithParser:(JSONParser *)parser]];
    [self.presenter setViewDelegate:self];
    self.catsArray = [NSArray array];
    [self.presenter downloadCats];
    [self setupCollectionView];
}

- (void)showCats:(NSArray<CatModel *>*)array {
    self.catsArray = array;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.collectionView reloadData];
    });
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width - 20, (self.view.bounds.size.height - 20) / 2);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //    flowLayout.headerReferenceSize = CGSizeMake(150, 100);
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.delegate = self.presenter;
    self.collectionView.dataSource = self.presenter;
    
    [self.presenter registerCellsFor:self.collectionView];
    
    [self.view addSubview:self.collectionView];
    
    self.collectionView.backgroundColor = UIColor.whiteColor;
    [self.collectionView setContentInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (@available(iOS 11.0, *)) {
        [NSLayoutConstraint activateConstraints:@[
            [self.collectionView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
            [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
            [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
            [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        ]];
    } else {
        [NSLayoutConstraint activateConstraints:@[
            [self.collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
            [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        ]];
    }
}


@end
