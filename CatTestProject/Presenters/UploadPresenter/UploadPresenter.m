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
                [weakSelf showErrorAlert:newStr];
            });
        }
    }];
}

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
