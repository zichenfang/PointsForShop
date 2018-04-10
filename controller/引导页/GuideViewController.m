//
//  GuideViewController.m
//  SuiTu
//
//  Created by 殷玉秋 on 2017/7/20.
//  Copyright © 2017年 fff. All rights reserved.
//

#import "GuideViewController.h"
#import "TTUserInfoManager.h"
#import "LoginViewController.h"

@interface GuideViewController ()
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIScrollView *scr = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scr.contentSize = CGSizeMake(self.view.frame.size.width*3, 0);
    scr.pagingEnabled = YES;
    scr.showsHorizontalScrollIndicator = NO;
    scr.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scr];
    for (int i=0; i<3; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [scr addSubview:imgView];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_%d",i]];
        if (i ==2) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goNext)];
            imgView.userInteractionEnabled = YES;
            [imgView addGestureRecognizer:tap];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)goNext{
    LoginViewController *vc = [[LoginViewController alloc] init];
    [[UIApplication sharedApplication] delegate].window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    [TTUserInfoManager setAppHasLaunched:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
