//
//  RegistrationVC.m
//  CatTestProject
//
//  Created by Антон Потапчик on 7/28/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "RegistrationVC.h"
#import "EnterApiKeyVC.h"
#import "RegistrationPresenter.h"

@interface RegistrationVC ()

@property (nonatomic, strong) RegistrationPresenter *presenter;
@property (weak, nonatomic) IBOutlet UITextField *loginTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UILabel *registrationLabel;
@property (weak, nonatomic) IBOutlet UIButton *registrationButton;

@end

@implementation RegistrationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [[RegistrationPresenter alloc] initWithUser] ;
    [self.presenter setRegistrationViewDelegate:self];
    
    [self.loginTF addTarget:self action:@selector(loginTFDidChange:)forControlEvents:UIControlEventEditingChanged];
    [self.passwordTF addTarget:self action:@selector(passwordTFDidChange:)forControlEvents:UIControlEventEditingChanged];
    [self.registrationButton setEnabled:NO];
    [self setuNavBackButton];
    
}

- (void)setuNavBackButton {
    UIBarButtonItem *myBackButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:nil];
    myBackButton.tintColor = [UIColor blackColor];
    self.navigationItem.backBarButtonItem = myBackButton;
}

- (IBAction)nextButtonPressed:(UIButton *)sender {
    [self.presenter checkUserCurrentLogin:self.loginTF.text];
}

- (void)loginTFDidChange:(UITextField *)textField {
    if (![self.passwordTF.text isEqualToString:@""] & ![textField.text isEqualToString:@""]) {
        [self.registrationButton setEnabled:YES];
    } else {
        [self.registrationButton setEnabled:NO];
    }
}

- (void)passwordTFDidChange:(UITextField *)textField {
    if (![self.loginTF.text isEqualToString:@""] & ![textField.text isEqualToString:@""]) {
        [self.registrationButton setEnabled:YES];
    } else {
        [self.registrationButton setEnabled:NO];
    }
}

- (void)presentEnterAPIVC {
    EnterApiKeyVC *vc = [[EnterApiKeyVC alloc]initWithNibName:@"EnterApiKeyVC" bundle:nil];
    vc.loginString = self.loginTF.text;
    vc.passwordString = self.passwordTF.text;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showAlreadyExistAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Current login is already exist. Try another one." preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        weakSelf.tabBarController.selectedIndex = 0;
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
