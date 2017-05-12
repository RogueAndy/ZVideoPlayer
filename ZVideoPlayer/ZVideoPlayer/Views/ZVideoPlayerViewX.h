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
@property (nonatomic, strong) void (^removeViewBlock)(void);
@property (nonatomic, strong) void (^willFullScreenBlock)(void);
@property (nonatomic, strong) void (^willUnFullScreenBlock)(void);
@property (nonatomic, strong) UIView *bgView;

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
