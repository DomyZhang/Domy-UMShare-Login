//
//  ThirdUMLogin.m
//  PalaceFeast
//
//  Created by yrtt on 16/9/8.
//  Copyright © 2016年 hong. All rights reserved.
//

#import "ThirdUMLogin.h"

#define fInfo @"授权失败，请您稍后再试！"

@implementation ThirdUMLogin

+ (void)loginWithType:(UMLoginType)type
       viewController:(UIViewController *)vc
          resultBlock:(UMLoginResultBlock)resultBlock {
    switch (type) {
            // 新浪登录
        case UMLoginTypeSina:
        {
            
            [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:vc completion:^(id result, NSError *error) {
                if (error) {
                    [[AlertUtil alertManager] showPromptInfo:fInfo];
                } else {
                    UMSocialUserInfoResponse *resp = result;
                    
                    // 第三方平台SDK源数据
                    NSLog(@"Sina originalResponse: %@", resp.originalResponse);
                    if (resultBlock != nil) {
                        resultBlock(resp,type);
                    }

                }
            }];
        }
            break;
            // QQ登录
        case UMLoginTypeQQ:
        {
            [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:vc completion:^(id result, NSError *error) {
                if (error) {
                    [[AlertUtil alertManager] showPromptInfo:fInfo];
                } else {
                    UMSocialUserInfoResponse *resp = result;
                    
                    // 第三方平台SDK源数据
                    NSLog(@"QQ originalResponse: %@", resp.originalResponse);
                    if (resultBlock != nil) {
                        resultBlock(resp,type);
                    }
                    
                }
            }];
        }
            break;
            // 微信登录
        case UMLoginTypeWeChat:
        {
            [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:vc completion:^(id result, NSError *error) {
                if (error) {
                    [[AlertUtil alertManager] showPromptInfo:fInfo];
                } else {
                    UMSocialUserInfoResponse *resp = result;
                    
                    // 授权信息
                    NSLog(@"weixin uid: %@", resp.uid);
                    NSLog(@"weixin accessToken: %@", resp.accessToken);
                    NSLog(@"weixin refreshToken: %@", resp.refreshToken);
                    NSLog(@"weixin expiration: %@", resp.expiration);
                    
                    // 用户信息
                    NSLog(@"weixin name: %@", resp.name);
                    NSLog(@"weixin iconurl: %@", resp.iconurl);
                    NSLog(@"weixin gender: %@", resp.gender);
                    
                    // 第三方平台SDK源数据
                    NSLog(@"weixin originalResponse: %@", resp.originalResponse);
                    if (resultBlock != nil) {
                        resultBlock(resp,type);
                    }
                    
                }
            }];
        }
            break;
            
        default:
            break;
    }
}


// 计时
+ (void)timeCountDownWithTimeout:(int)tout showButton:(UIButton *)button {
    
    __block int timeout = tout;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(timer, ^{
        
        if(timeout<=0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置按钮显示
                [button setTitle:@"重新获取" forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
            });
        } else {
            
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                // 设置按钮显示
                [button setTitle:[NSString stringWithFormat:@"%@(S)",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                button.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(timer);
}

@end
