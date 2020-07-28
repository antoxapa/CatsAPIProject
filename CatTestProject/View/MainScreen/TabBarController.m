//
//  TabBarController.m
//  CatTestProject
//
//  Created by Антон Потапчик on 7/27/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "TabBarController.h"
#import "MainViewController.h"
#import "LikedViewController.h"
#import "LoginViewController.h"

@interface TabBarController ()

@property (nonatomic, strong) UINavigationController *firstVC;
@property (nonatomic, strong) LikedViewController *secondVC;
@property (nonatomic, strong) LoginViewController *thirdVC;

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.barTintColor = [UIColor systemOrangeColor];
    self.tabBar.tintColor = [UIColor blackColor];
    self.tabBar.unselectedItemTintColor = [UIColor whiteColor];
    
    [self setupViews];
}

- (void)setupViews {
    MainViewController *firstTab = [[MainViewController alloc]init];
    UITabBarItem *infoTab = [[UITabBarItem alloc]initWithTitle:nil image:[UIImage imageNamed:@"cat_unselected"] selectedImage:[UIImage imageNamed:@"cat_selected"]];
    firstTab.tabBarItem = infoTab;
    
    self.firstVC = [[UINavigationController alloc]initWithRootViewController:firstTab];
    self.firstVC.navigationBar.clipsToBounds = true;
    self.firstVC.navigationBar.barTintColor = [UIColor systemOrangeColor];
    self.firstVC.navigationBar.translucent = NO;
    self.firstVC.navigationBar.layer.cornerRadius = 10;
    self.firstVC.navigationBar.layer.maskedCorners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    
    LikedViewController *secondTab = [[LikedViewController alloc]init];
    
    secondTab.view.backgroundColor = [UIColor whiteColor];
    UITabBarItem *galleryTab = [[UITabBarItem alloc]initWithTitle:nil image:[UIImage imageNamed:@"like_unselected"] selectedImage:[UIImage imageNamed:@"like_selected"]];
    secondTab.tabBarItem = galleryTab;
    self.secondVC = secondTab;
    
    LoginViewController *thirdTab = [[LoginViewController alloc]init];
    UITabBarItem *login = [[UITabBarItem alloc]initWithTitle:nil image:[UIImage imageNamed:@"login_unselected"] selectedImage:[UIImage imageNamed:@"login_selected"]];
    
    thirdTab.tabBarItem = login;
    
    self.thirdVC = thirdTab;
    
    self.viewControllers = @[self.firstVC, self.secondVC, self.thirdVC];
    self.selectedIndex = 0;
}

@end
