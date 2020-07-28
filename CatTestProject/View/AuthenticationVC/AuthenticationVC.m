//
//  AuthenticationVC.m
//  CatTestProject
//
//  Created by Антон Потапчик on 7/28/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "AuthenticationVC.h"
#import "TabBarController.h"

@interface AuthenticationVC ()

@property (weak, nonatomic) IBOutlet UITextField *loginTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *showCatsButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@end

@implementation AuthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
}
- (IBAction)showCatsButtonPressed:(UIButton *)sender {
    TabBarController *mainTBC = [[TabBarController alloc]init];
    [self.navigationController pushViewController:mainTBC animated:YES];
}
- (IBAction)registerButtonPressed:(UIButton *)sender {
    
}

@end
