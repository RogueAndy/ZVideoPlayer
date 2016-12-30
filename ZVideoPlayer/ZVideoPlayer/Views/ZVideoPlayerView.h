//
//  ZVideoPlayerView.h
//  ZVideoPlayer
//
//  Created by dazhongge on 2016/12/29.
//  Copyright © 2016年 dazhongge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZVideoPlayerView : UIView

/**
 关闭视图层索要执行的时间(execute method when close ZVideoPlayerView, you could set some animation to close ZVideoPlayerView and need to removeFromSuperview(), superView.ZVideoPlayerView = nil)
 */
@property (nonatomic, strong) void (^removeViewBlock)(void);

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

@end
