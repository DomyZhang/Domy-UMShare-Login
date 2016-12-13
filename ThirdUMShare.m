//
//  GuoRanShare.m
//  GuoranCommunity
//
//  Created by yrtt on 15/12/19.
//  Copyright © 2015年 vector. All rights reserved.
//

#import "ThirdUMShare.h"

#define ScreenHeight   [UIScreen mainScreen].bounds.size.height
#define ScreenWidth    [UIScreen mainScreen].bounds.size.width
#define TopWindow [UIApplication sharedApplication].keyWindow
//#define window         [[UIApplication sharedApplication].windows objectAtIndex:0]



@interface ThirdUMShare () {
    NSDictionary *shareSource;
}
@end

@implementation ThirdUMShare

/**************************************************************************************
 // 示例
 UIButton *button = [[ThirdUMShare shareManager] createButtonWithFrame:CGRectMake(100, 100, 100, 100) title:@"share" imageName:@"" viewController:self shareText:@"分享文字" shareImage:@"Tomato" urlResource:@"http://baidu.com" shareTitle:@"标题"];
 
 *********************************************************************************/
+ (ThirdUMShare *)shareManager {
    static dispatch_once_t once_token;
    static ThirdUMShare *share;
    dispatch_once(&once_token, ^{
        share = [[ThirdUMShare alloc] init];
    });
    return share;
}

- (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title
                    imageName:(NSString *)imageName
               viewController:(UIViewController *)vc
                    shareText:(NSString *)text
                   shareImage:(NSString *)image
//                     location:(CLLocation *)location
                  urlResource:(NSString *)url
                   shareTitle:(NSString *)shareTitle {
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showShareView) forControlEvents:UIControlEventTouchUpInside];
    shareSource = [NSDictionary dictionaryWithObjectsAndKeys:vc,@"vc", text,@"shareText",image,@"shareImage",url,@"urlResource",shareTitle,@"shareTitle", nil];
    [vc.view addSubview:button];
    return button;
}

- (void)showShareView {
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    shareView.alpha = 0.6;
    shareView.tag = 3333;
    shareView.backgroundColor = [UIColor blackColor];
    
    UIView *preShareView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight/2)];
    preShareView.tag = 4444;
    // 动画
    [UIView animateWithDuration:0.5 animations:^{
        CGRect preFrame = preShareView.frame;
        preFrame.origin.y -= ScreenHeight/2;
        preShareView.frame = preFrame;
    } completion:^(BOOL finished) {
    }];
    __weak typeof(shareView) sv = shareView;
    __weak typeof(preShareView) psv = preShareView;
    
    NSArray *imageArray =  @[@"share_sina",@"share_wechat",@"share_wechatLine",@"share_qq",@"share_qqzone",@"share_tencent"];
    CGFloat space = 46;
    CGFloat width = (ScreenWidth-4*space)/3;
    for (int i=0; i<6; i++) {
        UIButton *button = [preShareView addImageButtonWithFrame:CGRectMake(space+i%3*(space+width),50+i/3*(space+width), space, space) title:nil image:imageArray[i] action:^(ZYButton *button) {
            if (button.tag < 10006) {
                [ThirdUMShare shareWithText:shareSource[@"shareText"] image:shareSource[@"shareImage"] type:(UMShareType)button.tag-10000 viewController:shareSource[@"vc"] location:shareSource[@"location"] urlResource:shareSource[@"urlResource"] shareTitle:shareSource[@"shareTitle"]];
            }
            // 确定分享后，view移除
            [sv removeFromSuperview];
            [psv removeFromSuperview];
        }];
        button.tag = 10000+i;
        [TopWindow addSubview:shareView];
        [TopWindow addSubview:preShareView];
    }
    /*
    // 隐藏未安装客户端
    if (![QQApiInterface isQQInstalled]) {
        UIButton *qqbtn = [psv viewWithTag:10001];
        UIButton *qqzonebtn = [psv viewWithTag:10004];
        qqbtn.hidden = YES;
        qqzonebtn.hidden = YES;
    }
    if (![WXApi isWXAppInstalled]) {
        UIButton *wxSessionbtn = [psv viewWithTag:10003];
        UIButton *wxTimebtn = [psv viewWithTag:10005];
        wxSessionbtn.hidden = YES;
        wxTimebtn.hidden = YES;
    }
     */
    [preShareView addImageButtonWithFrame:CGRectMake(kScreenWidth/2-17, preShareView.frame.size.height-50, 34, 34) title:nil image:@"share_cancel" action:^(ZYButton *button) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect preFrame = psv.frame;
            preFrame.origin.y += ScreenHeight/2;
            psv.frame = preFrame;
        } completion:^(BOOL finished) {
            [sv removeFromSuperview];
            [psv removeFromSuperview];
        }];
    }];
    //点击空白收起分享view
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelShare:)];
    [shareView addGestureRecognizer:tap];
}

- (void)cancelShare:(UITapGestureRecognizer *)tap {
    UIView *view = (UIView *)[TopWindow viewWithTag:3333];
    UIView *pview = (UIView *)[TopWindow viewWithTag:4444];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect preFrame = pview.frame;
        preFrame.origin.y += ScreenHeight/2;
        pview.frame = preFrame;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        [pview removeFromSuperview];
    }];
}

/**
 友盟分享
 分享类型默认为图文类型
 
 @param text            分享内容
 @param image           分享的图片
 @param type            分享到的平台
 @param vc              控制器
 @param location        分享的地理位置信息
 @param urlResource     分享内容点击后跳转至链接
 @param shareTitle      分享title(微信、QQ)
 */
+ (void)shareWithText:(NSString *)text
                image:(NSString *)image
                 type:(UMShareType)type
       viewController:(UIViewController *)vc
             location:(CLLocation *)location
          urlResource:(NSString *)url
           shareTitle:(NSString *)shareTitle {
    
    if (0 < type && type < 5) {
        if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]) {
            [AlertUtil showAlertInfoSingle:@"您没有安装此应用哦"];
            return;
        }else if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
            [AlertUtil showAlertInfoSingle:@"您没有安装此应用哦"];
            return;
        }
    }
    
    UMShareWebpageObject *webOBJ = [UMShareWebpageObject shareObjectWithTitle:shareTitle descr:text thumImage:[UIImage imageNamed:@""]];
    
    if ([image hasPrefix:@"http://"] || [image hasPrefix:@"https://"]) {
        [webOBJ setThumbImage:image];
    }else {
        webOBJ.thumbImage = [UIImage imageNamed:@"image"];
    }
    webOBJ.webpageUrl = url;
    
    UMSocialMessageObject *messageOBJ = [UMSocialMessageObject messageObject];
    messageOBJ.text = text;
    messageOBJ.shareObject = webOBJ;

//    UMShareObject *object = [[UMShareObject alloc] init];
//    object.title = text;
//    object.thumbImage = image;
    
    if (type >= 3) {
        type +=1;
    }
    [[UMSocialManager defaultManager] shareToPlatform:(UMSocialPlatformType)type messageObject:messageOBJ currentViewController:vc completion:^(id result, NSError *error) {
        if (error) {
            NSString *str = [NSString stringWithFormat:@"%@",error];
            [[AlertUtil alertManager] showPromptInfo:str];
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",result);
        }
    }];
}

@end
