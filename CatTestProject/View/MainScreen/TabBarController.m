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
@property (nonatomic, strong) UINavigationController *secondVC;
@property (nonatomic, strong) LoginViewController *thirdVC;

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    self.tabBar.barTintColor = [UIColor systemOrangeColor];
    self.tabBar.tintColor = [UIColor blackColor];
    self.tabBar.unselectedItemTintColor = [UIColor whiteColor];
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
    
    UITabBarItem *likedTab = [[UITabBarItem alloc]initWithTitle:nil image:[UIImage imageNamed:@"upload_unselected"] selectedImage:[UIImage imageNamed:@"upload_selected"]];
    secondTab.tabBarItem = likedTab;
    
    self.secondVC = [[UINavigationController alloc]initWithRootViewController:secondTab];
    self.secondVC.navigationBar.clipsToBounds = true;
    self.secondVC.navigationBar.barTintColor = [UIColor systemOrangeColor];
    self.secondVC.navigationBar.translucent = NO;
    self.secondVC.navigationBar.layer.cornerRadius = 10;
    self.secondVC.navigationBar.layer.maskedCorners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    
    LoginViewController *thirdTab = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UITabBarItem *login = [[UITabBarItem alloc]initWithTitle:nil image:[UIImage imageNamed:@"login_unselected"] selectedImage:[UIImage imageNamed:@"login_selected"]];

    self.thirdVC = thirdTab;
    thirdTab.tabBarItem = login;
    self.viewControllers = @[self.firstVC, self.secondVC, self.thirdVC];
    self.selectedIndex = 0;
}

@end
