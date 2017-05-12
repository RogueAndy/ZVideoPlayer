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
@property (nonatomic, strong) UIView *bgView;
- (void)setImage:(NSString *)image urlString:(NSString *)urlString cellIndex:(NSInteger)index clickCell:(void (^)(NSInteger))block;

- (void)closePlayer;

@end
