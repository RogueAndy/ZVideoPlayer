//
//  ZVideoPlayerView.h
//  ZVideoPlayer
//
//  Created by dazhongge on 2016/12/29.
//  Copyright © 2016年 dazhongge. All rights reserved.
//

#import "ZBaseView.h"

@interface ZVideoPlayerView : ZBaseView

/**
 播放本地视频

 @param filePath 本地视频路径
 @return 返回对象
 */
+ (instancetype)initWithLocalVideo:(NSString *)filePath;


/**
 播放网络视频

 @param fileUrl 网络视频地址
 @return 返回对象
 */
+ (instancetype)initWithOnlineVideo:(NSString *)fileUrl;

@end