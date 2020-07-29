//
//  EnterApiKeyVC.m
//  CatTestProject
//
//  Created by Антон Потапчик on 7/28/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "EnterApiKeyVC.h"
#import "TabBarController.h"
#import "ApiViewPresenter.h"

@interface EnterApiKeyVC ()

@property (nonatomic, strong) ApiViewPresenter *presenter;
@property (weak, nonatomic) IBOutlet UITextField *apiTF;
@property (weak, nonatomic) IBOutlet UIButton *getAPIButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation EnterApiKeyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [[ApiViewPresenter alloc]initWithUser];
    [self.presenter setApiViewDelegate:self];
    
    [self.registerButton setEnabled:NO];
    [self.apiTF addTarget:self
                   action:@selector(apiEntered:)
         forControlEvents:UIControlEventEditingChanged];
}

- (IBAction)getAPIButtonTapped:(UIButton *)sender {
    [self.presenter showApiWebPage];
}

- (IBAction)registerButtonTapped:(UIButton *)sender {
    [self.presenter registerUserAndPushMainVC:self.loginString password:self.passwordString apiKey:self.apiTF.text isActive:@"YES"];
}

- (void)showAPIWebPage {
    [UIApplication.sharedApplication openURL:[NSURL URLWithString:@"https://thecatapi.com/signup"] options:@{} completionHandler:nil];
}

- (void)pushMainVC {
    TabBarController *mainTBC = [[TabBarController alloc]init];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:mainTBC animated:YES];
}

- (void)apiEntered:(UITextField *)textField {
    if (![textField.text isEqualToString:@""]) {
        [self.registerButton setEnabled:YES];
    } else {
        [self.registerButton setEnabled:NO];
    }
}

@end
