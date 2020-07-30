//
//  CustomNavController.m
//  CatTestProject
//
//  Created by Антон Потапчик on 7/30/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "CustomNavController.h"

@interface CustomNavController ()

@end

@implementation CustomNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


@end
