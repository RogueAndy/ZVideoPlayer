//
//  ZVideoListCell.h
//  ZVideoPlayer
//
//  Created by rogue on 2017/5/11.
//  Copyright © 2017年 dazhongge. All rights reserved.
//

#import "ZBaseTableViewCell.h"

@interface ZVideoListCell : ZBaseTableViewCell

@property (nonatomic, strong) UIViewController *superViewController;

@property (nonatomic, strong) CGRect (^returnCellRectInSuperView)(void);

/**
 给 cell 传入参数

 @param image 图像
 @param urlString 播放视频地址
 @param index 点击了第几个 cell, 用来记录上一次播放的 cell,当用户点击了下一个 cell的时候，控制上一个 cell 关闭播放
 @param block 点击之后的回调
 */
- (void)setImage:(NSString *)image urlString:(NSString *)urlString cellIndex:(NSInteger)index clickCell:(void (^)(NSInteger))block;

/**
 外部控制关闭播放器
 */
- (void)closePlayer;

/**
 滑动时候，若有视频在播放，并且播放视频所在 cell 超出了屏幕当前范围，则关闭播放器
 */
- (void)scrollClosePlayer;

@end
