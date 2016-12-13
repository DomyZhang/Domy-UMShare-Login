//
//  ViewController.m
//  ZYUMDemo
//
//  Created by yrtt on 16/12/13.
//  Copyright © 2016年 ZhangYing. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUM];
}

- (void)initUM {
    UIButton *shareutton = [[ThirdUMShare shareManager] createButtonWithFrame:CGRectMake(10, 100, 100, 50) title:@"分享按钮" imageName:@"" viewController:self shareText:@"分享text" shareImage:@"share_tencent" urlResource:@"https://baidu.com" shareTitle:@"titel"];
    shareutton.backgroundColor = [UIColor redColor];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginButton.frame = CGRectMake(10, 200, 100, 50);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor redColor];
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
}

- (void)login:(UIButton *)sender {
    [ThirdUMLogin loginWithType:UMLoginTypeQQ viewController:self resultBlock:^(UMSocialUserInfoResponse *snsAccount, UMLoginType type) {
        NSLog(@"%@",snsAccount);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
