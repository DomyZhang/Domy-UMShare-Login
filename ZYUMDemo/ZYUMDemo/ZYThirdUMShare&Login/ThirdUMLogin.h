//
//  ThirdUMLogin.h
//  PalaceFeast
//
//  Created by yrtt on 16/9/8.
//  Copyright © 2016年 hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    
    UMLoginTypeWeChat,    // 微信登录
    UMLoginTypeQQ,        // QQ登录
    UMLoginTypeSina       // 新浪登陆
    
}UMLoginType;

typedef void(^UMLoginResultBlock)(UMSocialUserInfoResponse *snsAccount,UMLoginType type);

@interface ThirdUMLogin : NSObject

/**
 友盟第三方登录
 
 @param type            登录到的平台
 @param vc              控制器
 @param resultBlock     block
 */
+ (void)loginWithType:(UMLoginType)type
       viewController:(UIViewController *)vc
          resultBlock:(UMLoginResultBlock)resultBlock;


// 倒计时
+ (void)timeCountDownWithTimeout:(int)tout showButton:(UIButton *)button;

@end
