//
//  LoginViewController.m
//  CatTestProject
//
//  Created by Антон Потапчик on 7/28/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewPresenter.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIView *topHeaderView;
@property (weak, nonatomic) IBOutlet UIStackView *titlesStackView;
@property (weak, nonatomic) IBOutlet UIStackView *buttonsStackView;

@property (weak, nonatomic) IBOutlet UITextField *loginTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *apiKeyTF;
@property (weak, nonatomic) IBOutlet UIButton *editButton;


@property (strong, nonatomic) LoginViewPresenter *presenter;
@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [[LoginViewPresenter alloc]initWithUser];
    
    [self.presenter setLoginViewDelegate:self];
    
    self.topHeaderView.clipsToBounds = YES;
    self.topHeaderView.layer.cornerRadius = 10;
    self.topHeaderView.layer.maskedCorners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    [self.apiKeyTF setUserInteractionEnabled:NO];
    [self.loginTF setUserInteractionEnabled:NO];
    [self.passwordTF setUserInteractionEnabled:NO];
    
    [self checkUserStatus];
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)checkUserStatus {
    NSDictionary *user = [self.presenter checkUserActivityStatus];
    if (user) {
        self.apiKeyTF.text = user[@"ApiKey"];
        self.loginTF.text = user[@"Login"];
        self.passwordTF.text = user[@"Password"];
    }
}

- (IBAction)editButtonPressed:(UIButton *)sender {
    [self.presenter changeProfileValues];
}
- (IBAction)logoutButtonPressed:(UIButton *)sender {
    [self.presenter logout];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)showAlertController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Not registered!" message:@"To get access full functional please register!" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *OK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        weakSelf.tabBarController.selectedIndex = 0;
    }];
    [alert addAction:OK];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)changeProfileValues {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = self.loginTF.text;
        textField.secureTextEntry = NO;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = self.passwordTF.text;
        textField.secureTextEntry = NO;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = self.apiKeyTF.text;
        textField.secureTextEntry = NO;
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.loginTF.text = [[alertController textFields][0] text];
        weakSelf.passwordTF.text = [[alertController textFields][1] text];
        weakSelf.apiKeyTF.text = [[alertController textFields][2] text];
        [self.presenter changeValues:weakSelf.loginTF.text password:weakSelf.passwordTF.text apiKey:weakSelf.apiKeyTF.text];
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

//- (void)checkUser:(NSString *)login password:(NSString *)password apiKey:(NSString *)apiKey registered:(BOOL)registered {
//    self.loginTF.text = login;
//    self.passwordTF.text = password;
//    self.apiKeyTF.text = apiKey;
//    self.registeredUser = registered;
//}

@end
