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
@end

@implementation LikedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.presenter = [[UploadPresenter alloc]initWithUser];
    [self.presenter setLikedViewDelegate:self];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIBarButtonItem *upload=[[UIBarButtonItem alloc]initWithImage:
                             [[UIImage imageNamed:@"upload_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                            style:UIBarButtonItemStylePlain target:self action:@selector(uploadImage)];
    self.navigationItem.rightBarButtonItem = upload;
    [self.presenter checkUserRegistered];
}

- (void)checkUserRegistered:(NSString *)apiKey {
    [self setupCollectionView];
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

- (void)uploadImage {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self.presenter;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.presenter showViewController:picker];
}

#pragma mark:- UICollectionViewDataSource methods

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor redColor];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
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

- (void)presentVC:(UIViewController *)controller {
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)dismisVC:(UIViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)showErrorAlert:(NSString *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
