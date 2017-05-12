//
//  ZSinglePlayerX.h
//  ZVideoPlayer
//
//  Created by rogue on 2017/5/11.
//  Copyright © 2017年 dazhongge. All rights reserved.
//

#import "ZVideoPlayerViewX.h"

@interface ZSinglePlayerX : ZVideoPlayerViewX

/**
 获取单例对象

 @return 返回 ZSinglePlayerX
 */
+ (instancetype)shareInstance;

/**
 播放在线视频

 @param fileUrl 视频地址
 @return 视频对象
 */
+ (instancetype)initWithOnlineVideo:(NSString *)fileUrl;

/**
 外部控制关闭播放器
 */
+ (void)closePlayer;

@end
