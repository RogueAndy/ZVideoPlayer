//
//  ZVideoPlayerView.h
//  ZVideoPlayer
//
//  Created by dazhongge on 2016/12/29.
//  Copyright © 2016年 dazhongge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZVideoPlayerView : UIView

///**
// 点击放大屏幕或者缩小屏幕时候的回调函数，当然，fullRect 代表满屏后的大小(可为nil), scaleRect 代表缩小后的屏幕大小(可为nil)
// */
//@property (nonatomic, strong) void (^fullOrScale)(void);

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
