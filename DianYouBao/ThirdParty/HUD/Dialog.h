

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface Dialog : NSObject<MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
    
	long long expectedLength;
	long long currentLength;
}

//提示对话框
- (void)alert:(NSString *)message;

//类似于Android一个显示框效果
- (void)toast:(UIViewController *)controller withMessage:(NSString *) message;

//带遮罩效果的进度条
- (void)gradient:(UIViewController *)controller seletor:(SEL)method;

//显示遮罩
- (void)showProgress:(UIViewController *)controller;

//关闭遮罩
- (void)hideProgress;

//带说明的进度条
- (void)progressWithLabel:(UIViewController *)controller seletor:(SEL)method;

//显示带说明的进度条
- (void)showProgress:(UIViewController *)controller withLabel:(NSString *)labelText;

@end
