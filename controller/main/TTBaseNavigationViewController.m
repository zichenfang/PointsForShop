//
//  TTBaseNavigationViewController.m
//  SuiTu
//
//  Created by 殷玉秋 on 2017/6/25.
//  Copyright © 2017年 fff. All rights reserved.
//

#import "TTBaseNavigationViewController.h"

@interface TTBaseNavigationViewController ()

@end

@implementation TTBaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.topViewController supportedInterfaceOrientations];
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

@end
