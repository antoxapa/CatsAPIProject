//
//  CatCell.h
//  CatTestProject
//
//  Created by Антон Потапчик on 7/25/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CatCell : UICollectionViewCell

@property (nonatomic, strong) NSString *catImageURL;
@property (nonatomic, strong) UIImageView *catImageView;

@end

NS_ASSUME_NONNULL_END
