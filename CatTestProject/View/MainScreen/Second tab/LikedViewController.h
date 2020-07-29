//
//  LikedViewController.h
//  CatTestProject
//
//  Created by Антон Потапчик on 7/27/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikedViewDelegate.h"
#import "ShowDismissProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LikedViewController : UIViewController <LikedViewDelegate, ShowDismissProtocol , UICollectionViewDelegate, UICollectionViewDataSource>

@end

NS_ASSUME_NONNULL_END
