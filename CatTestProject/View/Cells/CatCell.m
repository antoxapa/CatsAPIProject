//
//  CatCell.m
//  CatTestProject
//
//  Created by Антон Потапчик on 7/25/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "CatCell.h"

@implementation CatCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

-(void)setupViews {
    self.catImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cat"]];
    [self addSubview:self.catImageView];
    self.catImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.catImageView.layer.cornerRadius = 20;
    self.catImageView.layer.masksToBounds = YES;
    self.catImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.catImageView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor],
        [self.catImageView.leadingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.leadingAnchor],
        [self.catImageView.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor],
        [self.catImageView.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor],
    ]];
}

- (void)prepareForReuse {
    self.catImageURL = @"";
}
@end
