//
//  AuthenticationVC.m
//  CatTestProject
//
//  Created by Антон Потапчик on 7/28/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "AuthenticationVC.h"
#import "TabBarController.h"
#import "MainPresenter.h"
#import "RegistrationVC.h"

@interface AuthenticationVC ()

@property (weak, nonatomic) IBOutlet UITextField *loginTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *showCatsButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *apiKey;

@property (strong, nonatomic) MainPresenter *presenter;
@end

@implementation AuthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.presenter = [MainPresenter sharedInstance];
    [self.presenter setAuthViewDelegate:self];
    [self setuNavBackButton];
    
    [self.loginTF addTarget:self action:@selector(loginTFDidChange:)forControlEvents:UIControlEventEditingChanged];
    [self.loginButton setEnabled:NO];
    [self.passwordTF addTarget:self action:@selector(passwordTFDidChange:)forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)setuNavBackButton {
    UIBarButtonItem *myBackButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:nil];
    myBackButton.tintColor = [UIColor blackColor];
    self.navigationItem.backBarButtonItem = myBackButton;
}

- (void)loginTFDidChange:(UITextField *)textField {
    if (![self.passwordTF.text isEqualToString:@""] & ![textField.text isEqualToString:@""]) {
        [self.loginButton setEnabled:YES];
    } else {
        [self.loginButton setEnabled:NO];
    }
}

- (void)passwordTFDidChange:(UITextField *)textField {
    if (![self.loginTF.text isEqualToString:@""] & ![textField.text isEqualToString:@""]) {
        [self.loginButton setEnabled:YES];
    } else {
        [self.loginButton setEnabled:NO];
    }
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    BOOL hereWeAre = NO;
    NSArray *users = [[NSUserDefaults standardUserDefaults]objectForKey:@"Users"];
    for (NSDictionary *user in users) {
        self.login = user[@"Login"];
        self.password = user[@"Password"];
        self.apiKey = user[@"ApiKey"];
        
        if ([self.loginTF.text isEqualToString:self.login] && [self.passwordTF.text isEqualToString:self.password]) {
            hereWeAre = YES;
            [self.presenter pushRegisteredUser:self.login password:self.password apiKey:self.apiKey registered:YES];
            break;
        }
    }
    if (!hereWeAre) {
         [self.presenter showWrongDataAlert];
    }
}

- (IBAction)showCatsButtonPressed:(UIButton *)sender {
    [self.presenter pushMainVC];
}

- (IBAction)registerButtonPressed:(UIButton *)sender {
    [self.presenter pushRegistrationVC];
}

- (void)pushMainVC {
    TabBarController *mainTBC = [[TabBarController alloc]init];
    [self.navigationController pushViewController:mainTBC animated:YES];
}
- (void)pushRegisteredUser {
    TabBarController *mainTBC = [[TabBarController alloc]init];
    [self.navigationController pushViewController:mainTBC animated:YES];
}

- (void)pushRegistrationVC {
    RegistrationVC *registrationVC = [[RegistrationVC alloc]initWithNibName:@"RegistrationVC" bundle:nil];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:registrationVC animated:YES];
}

- (void)showWrongLoginOrPassword {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Wrond data" message:@"Wrong login or password" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
