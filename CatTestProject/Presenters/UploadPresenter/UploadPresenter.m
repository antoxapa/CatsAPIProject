//
//  UploadPresenter.m
//  CatTestProject
//
//  Created by Антон Потапчик on 7/30/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "UploadPresenter.h"
#import "LikedViewDelegate.h"
#import "ShowDismissProtocol.h"
#import "UserManager.h"
#import "CatCell.h"
#import "NetworkManager.h"
#import "JSONParser.h"


@interface UploadPresenter () 
@property (nonatomic, weak)  id<LikedViewDelegate, ShowDismissProtocol> likedView;
@property (nonatomic, strong)  UserManager *userManager;
@property (nonatomic, strong)  NetworkManager *networkManager;
@property (nonatomic, strong)  NSMutableArray<CatModel *> *uploadedCats;
@end
@implementation UploadPresenter

- (instancetype) initWithUser {
    self = [super init];
    if (self) {
        _userManager = [[UserManager alloc]init];
        _networkManager = [[NetworkManager alloc]initWithParser:[JSONParser alloc]];
    }
    return self;
}
-(void)setLikedViewDelegate:(id<LikedViewDelegate, ShowDismissProtocol>)view {
    self.likedView = view;
}

#pragma mark:- LikedViewDelegate methods

- (void)checkUserRegistered {
    BOOL registered = [self.userManager checkUserStatus];
    if (!registered) {
        [self.likedView showAlertController];
    } else {
        [self.likedView checkUserRegistered];
    }
}

-(void)registerCellsFor:(UICollectionView *)collectionView {
    [collectionView registerClass:[CatCell class] forCellWithReuseIdentifier:@"Cell"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
}

#pragma mark:- Downloading

- (void)startLoadingImages {
    if (!self.isLoaded) {
        [self.likedView startIndicator];
        self.isLoaded = YES;
        NSString *apiKey = [self getUserApi];
        __weak typeof(self)weakSelf = self;
        NSString *url = @"https://api.thecatapi.com/v1/images?limit=100";
        [self.networkManager parseUloadedData:url apiKey:apiKey completion:^(NSMutableArray<CatModel *> *array, NSError *error) {
            NSMutableArray *cats = array;
            [weakSelf.likedView addMoreImages:cats];
        }];
    }
}

- (void)uploadImage:(UIImage *)image andPath:(NSString *)fileName {
    NSDictionary *user = [self.userManager updateUserInfo];
    __weak typeof (self)weakSelf = self;
    [self.networkManager uploadImage:user[@"ApiKey"] fileName:fileName image:image completion:^(NSData *data, NSURLResponse * response, NSError * error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showErrorAlert:[NSString stringWithFormat:@"%@",error]];
            });
        }
        if (data) {
            NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", newStr);
            dispatch_async(dispatch_get_main_queue(), ^{
                //                [weakSelf showErrorAlert:newStr];
                [weakSelf getUploadedImagesArray];
            });
        }
    }];
}

- (void)getUploadedImagesArray {
    [self.likedView startIndicatorAnimating];
    NSString *apiKey = [self getUserApi];
    NSString *urlString = @"https://api.thecatapi.com/v1/images?limit=100";
    __weak typeof (self)weakSelf = self;
    [self.networkManager parseUloadedData:urlString apiKey:apiKey completion:^(NSMutableArray<CatModel *> *array, NSError *error) {
        if (!array && !error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.likedView showAuthErrorAlert];
            });
        }
        weakSelf.uploadedCats = array;
        [weakSelf.likedView showCats:array];
    }];
}

- (void)downloadImageForCell:(CatCell *)cell andIndexPath:(NSIndexPath *)indexPath {
    cell.catImageURL = self.uploadedCats[indexPath.row].url;
    __weak typeof(self)weakSelf = self;
    [self.networkManager getCachedImageWithURL:self.uploadedCats[indexPath.row].url completion:^(NSString *url, UIImage * image, NSError * error) {
        if (error) {
            NSLog(@"%@", error);
        }
        if (image) {
            if ([weakSelf.uploadedCats[indexPath.row].url isEqualToString:cell.catImageURL]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.catImageView.image = image;
                });
            }
        }
    }];
}

- (NSString *)getUserApi {
    return [self.userManager checkUserApi];
}

#pragma mark:- ImagePickerController delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSURL *fileNameURL = info[UIImagePickerControllerImageURL];
    NSString *fileName =  [NSString stringWithFormat:@"%@", fileNameURL];
    [self uploadImage:chosenImage andPath:fileName];
    [self dismisViewController:picker];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.likedView stopIndicatorAnimating];
    [self.likedView dismisVC:picker];
}

#pragma mark:- VC methods
- (void)startIndicatorAnimating {
    [self.likedView startIndicatorAnimating];
}

- (void)showViewController:(UIViewController *) viewController {
    [self.likedView presentVC:viewController];
}

- (void)showErrorAlert:(NSString *)message {
    [self.likedView showErrorAlert:message];
}

- (void)dismisViewController:(UIViewController *) viewController {
    [self.likedView dismisVC:viewController];
}

@end
