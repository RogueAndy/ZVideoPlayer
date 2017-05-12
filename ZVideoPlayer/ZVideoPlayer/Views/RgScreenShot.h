//
//  RgScreenShot.h
//  RgFeinno
//
//  Created by Rogue Andy on 16/8/30.
//  Copyright © 2016年 RogueAndy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RgScreenShot : NSObject

/**
 *  对控制器截屏
 *
 *  @param viewController 控制器
 *
 *  @return 截屏图像
 */

+ (UIImage *)imageWithViewController:(UIViewController *)viewController;

/**
 *  对 UIView 截屏
 *
 *  @param view 对象参数
 *
 *  @return 截屏图像
 */

+ (UIImage *)imageWithView:(UIView *)view;

/**
 *  对 UISrollerView 截屏，比如当使用到 UIWebView 时，使用 webview.scrollView 来存入参数
 *
 *  @param scrollView 对象参数
 *
 *  @return 截屏图像
 */

+ (UIImage *)imageWithScrollView:(UIScrollView *)scrollView;

@end
