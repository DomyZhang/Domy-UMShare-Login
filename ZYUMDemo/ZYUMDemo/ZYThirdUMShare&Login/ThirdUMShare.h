//
//  GuoRanShare.h
//  GuoranCommunity
//
//  Created by yrtt on 15/12/19.
//  Copyright © 2015年 vector. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/* 分享 */
typedef NS_ENUM(NSInteger,UMShareType) {
    UMShareTypeSina = 0,                // 新浪
    UMShareTypeWechatSession,           // 微信好友
    UMShareTypeWechatTimeLine,          // 微信朋友圈
    UMShareTypeWechatFavorite,          //  微信搜藏
    UMShareTypeQQ,                      // QQ
    UMShareTypeQzone,                   // QQ空间
};

@interface ThirdUMShare : NSObject //<UMSocialUIDelegate>



+ (ThirdUMShare *)shareManager;
- (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title
                    imageName:(NSString *)imageName
               viewController:(UIViewController *)vc
                    shareText:(NSString *)text
                   shareImage:(NSString *)image
//                     location:(CLLocation *)location
                  urlResource:(NSString *)url
                   shareTitle:(NSString *)shareTitle;









///**
// =========================== Deprecation ====================
// 分享功能 实现
// 
// @param alpha           分享view 是否透明(0或1)
// @param vc              控制器
// @param text            分享文字(可含URL:HTTP)
// @param image           分享图片名字(URL)
// @param location        分享的地理位置信息
// @param url             分享内容点击后跳转至链接
// @param shareTitle      分享title(微信、QQ)
// */
//+ (void)showShareViewWithAlpha:(CGFloat)alpha
//                viewController:(UIViewController *)vc
//                     shareText:(NSString *)text
//                    shareImage:(NSString *)image
//                      location:(CLLocation *)location
//                   urlResource:(NSString *)url
//                    shareTitle:(NSString *)shareTitle;


@end
