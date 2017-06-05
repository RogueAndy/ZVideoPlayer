//
//  ZVideoListCell.m
//  ZVideoPlayer
//
//  Created by rogue on 2017/5/11.
//  Copyright © 2017年 dazhongge. All rights reserved.
//

#import "ZVideoListCell.h"
#import "UIImageView+WebCache.h"
#import "ZSinglePlayerX.h"

@interface ZVideoListCell()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIButton *play;

@property (nonatomic, strong) NSString *urlString;

@property (nonatomic) NSInteger cellIndex;

@property (nonatomic, strong) void (^clickIndex)(NSInteger);

@end

@implementation ZVideoListCell

- (void)loadViews {

    [super loadViews];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.bgImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.bgImageView];

    self.play = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.play setImage:[UIImage imageNamed:@"player"] forState:UIControlStateNormal];
    [self.play addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImageView addSubview:self.play];
    
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    [self loadLayout];

}

- (void)loadLayout {

    [super loadLayout];
    
    self.bgImageView.frame = self.bounds;
    self.play.frame = CGRectMake(0, 0, 80, 80);
    self.play.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0);

}

- (void)setImage:(NSString *)image urlString:(NSString *)urlString cellIndex:(NSInteger)index clickCell:(void (^)(NSInteger))block {

    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"ddd"]];
    self.urlString = urlString;
    self.cellIndex = index;
    self.clickIndex = block;

}

#pragma mark - 响应播放视频事件，对播放器传入必要参数以及处理回调事件

- (void)play:(UIButton *)sender {

    self.clickIndex(self.cellIndex);
    
    // 开始给 视频播放器传入必要参数
    ZSinglePlayerX *player = [ZSinglePlayerX initWithOnlineVideo:_urlString];
    player.frame = self.bounds;
    player.backgroundColor = [UIColor blackColor];
    
    __weak ZVideoListCell *weakSelf = self;
    __weak ZSinglePlayerX *weakPlayer = player;
    player.removeViewBlock = ^{
        [weakSelf closePlayer];
    };
    player.willUnFullScreenBlock = ^{
//        [weakSelf showPlayer];
//        [weakPlayer showViewIn:weakSelf animation:NO];
        [weakSelf showPlayer];
        [weakPlayer showViewIn:weakSelf animation:NO animationComplete:nil];
    };
    player.willFullScreenBlock = ^{
        [weakSelf closePlayer];
    };
    player.superViewController = self.superViewController;
    player.returnCellRectInSuperView = self.returnCellRectInSuperView;
    
    [player showViewIn:self animation:YES animationComplete:^{
        [weakSelf showPlayer]; //隐藏 cell上的默认背景图
    }]; // 添加视频
//    player.isPlay = YES; // 开始播放
    
}

#pragma mark - 开启视频，隐藏背景图

- (void)showPlayer {

    self.bgImageView.hidden = YES;
    self.bgImageView.alpha = 0;

}

#pragma mark - 关闭视频，显示背景图

- (void)closePlayer {
    
    self.bgImageView.hidden = NO;
    self.bgImageView.alpha = 1;
    
}

#pragma mark - 滑动时候，若有视频在播放，并且播放视频所在 cell 超出了屏幕当前范围，则关闭播放器

- (void)scrollClosePlayer {

    if(self.bgImageView.hidden == YES) {
    
        [self closePlayer];
        
        ZSinglePlayerX *player = [ZSinglePlayerX shareInstance];
        [player setIsPlay:NO];
        [player closePlayer];
    
    }
    
}

@end
