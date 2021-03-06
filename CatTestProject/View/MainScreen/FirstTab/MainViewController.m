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
#import "CatCell.h"

@interface MainViewController () 

@property (nonatomic, strong) MainPresenter *presenter;
@property (nonatomic, strong) NSMutableArray<CatModel *> *catsArray;
@property (nonatomic, strong) UIView *footerIndicatorView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.presenter = [[MainPresenter alloc]init];
    [self.presenter initNetworkManager];
    
    [self.presenter setViewDelegate:self];
    self.catsArray = [NSMutableArray new];
    [self.presenter downloadCats];
    [self setupCollectionView];
    [self setupActivityIndicator];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIBarButtonItem *changeGrid=[[UIBarButtonItem alloc]initWithImage:
                                 [[UIImage imageNamed:@"icon1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                style:UIBarButtonItemStylePlain target:self action:@selector(changeLayout)];
    self.navigationItem.rightBarButtonItem = changeGrid;
}

- (void)setupActivityIndicator {
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.collectionView addSubview:self.indicator];
    self.indicator.color = UIColor.whiteColor;
    self.indicator.frame = CGRectMake(0, 0, 50, 50);
    
    self.indicator.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.indicator.centerXAnchor constraintEqualToAnchor:self.collectionView.centerXAnchor],
        [self.indicator.centerYAnchor constraintEqualToAnchor:self.collectionView.centerYAnchor],
    ]];
    [self.indicator setUserInteractionEnabled:NO];
    [self.indicator startAnimating];
}

- (void)setupCollectionView {
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    [self.layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.layout setSectionInset:UIEdgeInsetsMake(20, 10, 0, 10)];
    self.layout.sectionHeadersPinToVisibleBounds = YES;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.presenter registerCellsFor:self.collectionView];
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.collectionView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
    ]];
}

- (void)showCats:(NSMutableArray<CatModel *>*)array {
    self.catsArray = array;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.indicator stopAnimating];
        [weakSelf.collectionView reloadData];
    });
}

-(void)startIndicator {
    [self.loadingIndicator setHidden:NO];
    [self.loadingIndicator startAnimating];
}

- (void)changeLayout {
    [self.presenter gridButtonTapped];
}

- (void)addMoreImages:(NSMutableArray<CatModel *>*)array {
    [self.catsArray addObjectsFromArray:array];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.collectionView reloadData];
    });
    self.presenter.isLoaded = NO;
}

- (void)presentDetailViewController:(UIViewController *)controller {
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark:- UICollectionViewDataSource

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CatCell *cell = (CatCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [self.presenter downloadImageForCell:cell andIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
    self.loadingIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [footer addSubview:self.loadingIndicator];
    self.loadingIndicator.color = UIColor.whiteColor;
    self.loadingIndicator.frame = CGRectMake(0, 0, 30, 30);
    self.loadingIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.loadingIndicator.centerXAnchor constraintEqualToAnchor:footer.centerXAnchor],
        [self.loadingIndicator.centerYAnchor constraintEqualToAnchor:footer.centerYAnchor],
    ]];
    [self.loadingIndicator setUserInteractionEnabled:NO];
    return footer;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.catsArray.count;
}


#pragma mark:- UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.numberOfItems) {
        if (self.collectionView.frame.size.height>self.collectionView.frame.size.width) {
            self.numberOfItems = 1;
        }
        else{
            self.numberOfItems = 3;
        }
    }
    CGFloat width = (self.collectionView.frame.size.width - 40 - (self.numberOfItems-1) * 5) / self.numberOfItems;
    if (self.numberOfItems == 1) {
        CGFloat height = 300;
        return CGSizeMake(width, height);
    }
    return CGSizeMake(width, width);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        return 10;
    }
    return 30;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        return 10;
    }
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(self.collectionView.bounds.size.width, 50);
}

- (void)collectionView:(UICollectionView *)collectionView willdDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.presenter downloadCats];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
        [self.presenter cancelDownloadingImage:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.presenter pushDetailVC:indexPath];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        self.numberOfItems = 1;
        
    }
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)) {
        self.numberOfItems = 1;
    }
    
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        [self.presenter startLoadingImages];
    }
}

- (void)showAlertController:(NSString *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!" message:error preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *OK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
    }];
    [alert addAction:OK];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
