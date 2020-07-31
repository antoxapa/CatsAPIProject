//
//  LikedViewController.m
//  CatTestProject
//
//  Created by Антон Потапчик on 7/27/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "LikedViewController.h"
#import "UploadPresenter.h"
#import "CatCell.h"

@interface LikedViewController ()

@property (nonatomic, strong) UploadPresenter *presenter;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;

@property (nonatomic, strong) NSMutableArray<CatModel *> *uploadedCats;

@end

@implementation LikedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.uploadedCats = [NSMutableArray new];
    self.presenter = [[UploadPresenter alloc]initWithUser];
    [self.presenter setLikedViewDelegate:self];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.presenter checkUserRegistered];
   
}

- (void)checkUserRegistered {
    [self setupCollectionView];
    [self.presenter getUploadedImagesArray];
}

- (void)showAlertController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Not registered!" message:@"To get access full functional please register!" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        weakSelf.tabBarController.selectedIndex = 0;
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setupCollectionView {
    
    UIBarButtonItem *upload=[[UIBarButtonItem alloc]initWithImage:
                             [[UIImage imageNamed:@"upload_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                            style:UIBarButtonItemStylePlain target:self action:@selector(uploadImage)];
    self.navigationItem.rightBarButtonItem = upload;
    
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
    
    [self setupIndicator];
}

- (void)setupIndicator {
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.collectionView addSubview:self.indicator];
    self.indicator.color = [UIColor whiteColor];
    self.indicator.frame = CGRectMake(0, 0, 50, 50);
    self.indicator.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.indicator.centerXAnchor constraintEqualToAnchor:self.collectionView.centerXAnchor],
        [self.indicator.centerYAnchor constraintEqualToAnchor:self.collectionView.centerYAnchor],
    ]];
}

- (void)showCats:(NSMutableArray<CatModel *>*)array {
    self.uploadedCats = array;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.indicator stopAnimating];
        [weakSelf.collectionView reloadData];
    });
}

- (void)uploadImage {
//    [self.presenter startIndicatorAnimating];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self.presenter;
    picker.allowsEditing = YES;;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.presenter showViewController:picker];
}

- (void)addMoreImages:(NSMutableArray<CatModel *>*)array {
    NSUInteger count = self.uploadedCats.count;
    for (int i = 0; i < self.uploadedCats.count; i++) {
        if (array[i]) {
            if (![self.uploadedCats[i].imageID isEqualToString:array[i].imageID]) {
                [self.uploadedCats addObject:array[i]];
            }
        }
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.uploadedCats.count != count) {
            [weakSelf.collectionView reloadData];
        }
        [self.loadingIndicator stopAnimating];
    });
    self.presenter.isLoaded = NO;
}

#pragma mark:- UICollectionViewDataSource methods

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [self.presenter downloadImageForCell:cell andIndexPath:indexPath];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.uploadedCats.count;
}

#pragma mark:- UICollectionViewDelegate methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (self.collectionView.frame.size.width - 40 - 2 * 5) / 3;
    
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

#pragma mark:- VC methods

- (void)presentVC:(UIViewController *)controller {
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)dismisVC:(UIViewController *)controller {
    [self.indicator stopAnimating];
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)showErrorAlert:(NSString *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)showAuthErrorAlert {
    __weak typeof (self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Wrong API-KEY!" message:@"Please enter correct API-KEY" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        weakSelf.tabBarController.selectedIndex = 2;
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)startIndicator {
    [self.loadingIndicator setHidden:NO];
    [self.loadingIndicator startAnimating];
}

- (void)startIndicatorAnimating {
    [self.indicator startAnimating];
}

- (void)stopIndicatorAnimating {
    [self.indicator stopAnimating];
}
@end
