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
