//
//  ZVideoPlayerViewX.h
//  ZVideoPlayer
//
//  Created by rogue on 2017/5/11.
//  Copyright © 2017年 dazhongge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZVideoPlayerViewX : UIView

/**
 关闭视图层索要执行的时间(execute method when close ZVideoPlayerView, you could set some animation to close ZVideoPlayerView and need to removeFromSuperview(), superView.ZVideoPlayerView = nil)
 */

/**
 如果在视频专栏， 获取当前 cell 在控制器上的转换坐标，用于实现动画定位效果
 */
@property (nonatomic, strong) CGRect (^returnCellRectInSuperView)(void);

/**
 删除播放器之后执行
 */
@property (nonatomic, strong) void (^removeViewBlock)(void);

/**
 将会全屏时执行
 */
@property (nonatomic, strong) void (^willFullScreenBlock)(void);

/**
 将会缩小屏幕时执行
 */
@property (nonatomic, strong) void (^willUnFullScreenBlock)(void);

/**
 父控制器
 */
@property (nonatomic, strong) UIViewController *superViewController;

/**
 控制视频，开始播放或者暂停播放
 */
@property (nonatomic, assign) BOOL isPlay;

/**
 视频地址
 */
@property (nonatomic, strong) NSString *urlString;

/**
 播放本地视频
 
 @param filePath 本地视频路径(can't be nil, can't be '')
 @return 返回对象
 */
+ (instancetype)initWithLocalVideo:(NSString *)filePath;


/**
 播放网络视频
 
 @param fileUrl 网络视频地址(can't be nil, can't be '')
 @return 返回对象
 */
+ (instancetype)initWithOnlineVideo:(NSString *)fileUrl;

/**
 显示 ZVideoPlayerView ,替代 addSubview 方法
 
 @param superView 父类图
 @param animation 是否显示动画效果
 */
- (void)showViewIn:(UIView *)superView animation:(BOOL)animation;

/**
 关闭播放器
 */
- (void)closePlayer;

@end
