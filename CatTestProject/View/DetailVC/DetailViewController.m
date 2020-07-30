//
//  DetailViewController.m
//  CatTestProject
//
//  Created by Антон Потапчик on 7/28/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "DetailViewController.h"
#import <UIKit/UIKit.h>

@interface DetailViewController ()

@end

@implementation DetailViewController

- (instancetype)initWithImage:(UIImage *)image andURL:(NSString *)url {
    self = [super init];
    if (self) {
        _imageView = [[UIImageView alloc]initWithImage:image];
        _url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.presenter setDetailViewDelegate:self];
    
    [self.view addSubview:self.imageView];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *save = [UIImage imageNamed:@"save"];
    [self.saveButton setImage:save forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveImageToGallery) forControlEvents:UIControlEventTouchUpInside];
    
    self.saveButton.tintColor = [UIColor whiteColor];
    self.saveButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageView addSubview:self.saveButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.imageView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.imageView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.imageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        
        [self.saveButton.heightAnchor constraintEqualToConstant:50],
        [self.saveButton.widthAnchor constraintEqualToConstant:50],
        [self.saveButton.trailingAnchor constraintEqualToAnchor:self.imageView.trailingAnchor constant:-10],
        [self.saveButton.bottomAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:-10],
    ]];
    
    if ([self.imageView.image isEqual:[UIImage imageNamed:@"cat"]]) {
        [self.saveButton setHidden:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.imageView.image isEqual:[UIImage imageNamed:@"cat"]]) { [self.presenter setDetailViewDelegate:self];
        [self.presenter downloadImage:self.url];
    } else {
        [self.saveButton setHidden:NO];
    }
}

- (void)saveImageToGallery {
    [self.presenter saveImageInGallery:self.imageView.image];
    [self.presenter presentSaveAlertController];
}

- (void)showSavedStatusAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Saved!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
