//
//  EnterApiKeyVC.m
//  CatTestProject
//
//  Created by Антон Потапчик on 7/28/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "EnterApiKeyVC.h"
#import "TabBarController.h"

@interface EnterApiKeyVC ()
@property (weak, nonatomic) IBOutlet UITextField *apiTF;
@property (weak, nonatomic) IBOutlet UIButton *getAPIButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation EnterApiKeyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [MainPresenter sharedInstance];
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
    
    NSString *login = self.loginString;
    NSString *password = self.passwordString;
    NSString *apiKey = self.apiTF.text;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Users"]) {
        NSMutableArray *users = [[[NSUserDefaults standardUserDefaults]objectForKey:@"Users"] mutableCopy];
        NSDictionary *user = @{@"Login": login, @"Password":password, @"ApiKey":apiKey};
        [users addObject:user];
        [[NSUserDefaults standardUserDefaults] setObject:users forKey:@"Users"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSDictionary *user = @{@"Login": login, @"Password":password, @"ApiKey":apiKey};
        NSArray *users = [NSArray arrayWithObject:user];
        [[NSUserDefaults standardUserDefaults] setObject:users forKey:@"Users"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self.presenter pushRegisteredUser:self.loginString password:self.passwordString apiKey:self.apiTF.text registered:YES];
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
