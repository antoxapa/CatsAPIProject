//
//  DetailViewDelegate.h
//  CatTestProject
//
//  Created by Антон Потапчик on 7/28/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DetailViewDelegate <NSObject>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UIButton *saveButton;

- (instancetype)initWithImage:(UIImage *)image andURL:(NSString *)url;
- (void)showSavedStatusAlert;


@end

NS_ASSUME_NONNULL_END
