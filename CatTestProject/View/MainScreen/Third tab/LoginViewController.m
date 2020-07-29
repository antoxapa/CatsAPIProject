//
//  LoginViewController.m
//  CatTestProject
//
//  Created by Антон Потапчик on 7/28/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "LoginViewController.h"
#import "MainPresenter.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *topHeaderView;
@property (weak, nonatomic) IBOutlet UIStackView *titlesStackView;
@property (weak, nonatomic) IBOutlet UIStackView *buttonsStackView;

@property (weak, nonatomic) IBOutlet UITextField *loginTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *apiKeyTF;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property BOOL registeredUser;

@property (strong, nonatomic) MainPresenter *presenter;
@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [MainPresenter sharedInstance];
    [self.presenter setLoginViewDelegate:self];
    [self.presenter updateScreenWithData];
    
    self.topHeaderView.clipsToBounds = YES;
    self.topHeaderView.layer.cornerRadius = 10;
    self.topHeaderView.layer.maskedCorners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.registeredUser) {
        [self.titlesStackView setHidden:NO];
        [self.buttonsStackView setHidden:NO];
    } else {
        [self.titlesStackView setHidden:YES];
        [self.buttonsStackView setHidden:YES];
        [self.editButton setHidden:YES];
        [self.presenter showAlert];
    }
}

- (IBAction)editButtonPressed:(UIButton *)sender {
    [self.presenter changeProfileValues];
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
    NSMutableArray *users = [[[NSUserDefaults standardUserDefaults]objectForKey:@"Users"] mutableCopy];
    __weak typeof (self)weakSelf = self;
    for (int i = 0; i <users.count; i++) {
        NSMutableDictionary *mutableUser = [users[i] mutableCopy];
        
        if ([self.loginTF.text isEqualToString:mutableUser[@"Login"]]) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = self.loginTF.text;
                textField.secureTextEntry = NO;
            }];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = self.passwordTF.text;
                textField.secureTextEntry = NO;
            }];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = self.apiKeyTF.text;
                textField.secureTextEntry = NO;
            }];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                mutableUser[@"Login"] = [[alertController textFields][0] text];
                weakSelf.loginTF.text = [[alertController textFields][0] text];
                mutableUser[@"Password"] = [[alertController textFields][1] text];
                weakSelf.passwordTF.text = [[alertController textFields][1] text];
                mutableUser[@"ApiKey"] = [[alertController textFields][2] text];
                weakSelf.apiKeyTF.text = [[alertController textFields][2] text];
                
                [users replaceObjectAtIndex:i withObject:mutableUser];
                [weakSelf.presenter changeValues:weakSelf.loginTF.text password:weakSelf.passwordTF.text apiKey:weakSelf.apiKeyTF.text and:users];
            }];
            [alertController addAction:confirmAction];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
            break;
        }
    }
}

- (void)checkUser:(NSString *)login password:(NSString *)password apiKey:(NSString *)apiKey registered:(BOOL)registered {
    self.loginTF.text = login;
    self.passwordTF.text = password;
    self.apiKeyTF.text = apiKey;
    self.registeredUser = registered;
}

@end
