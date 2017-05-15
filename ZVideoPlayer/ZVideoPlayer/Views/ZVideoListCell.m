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

- (void)play:(UIButton *)sender {

    self.clickIndex(self.cellIndex);
    ZSinglePlayerX *player = [ZSinglePlayerX initWithOnlineVideo:_urlString];
    player.frame = self.bounds;
    player.backgroundColor = [UIColor blackColor];
    
    __block ZSinglePlayerX *strongPlayer = player;
    player.removeViewBlock = ^{
        
        self.bgImageView.hidden = NO;
        self.bgImageView.alpha = 1;
        [strongPlayer removeFromSuperview];
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.bgImageView.alpha = 1;
                             strongPlayer.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             
                             [strongPlayer removeFromSuperview];
                             
                         }];
        
    };
    
    __weak ZSinglePlayerX *weakPlayer = player;
    player.willUnFullScreenBlock = ^{
        [self showPlayer];
        [weakPlayer showViewIn:self animation:YES];
    };
    
    player.willFullScreenBlock = ^{
        [self closePlayer];
    };

    [player showViewIn:self animation:YES];
    player.isPlay = YES;
    self.bgImageView.hidden = YES;
    self.bgImageView.alpha = 0;
    
    player.superViewController = self.superViewController;
    player.returnCellRectInSuperView = self.returnCellRectInSuperView;
    
}

- (void)closePlayer {

    self.bgImageView.hidden = NO;
    self.bgImageView.alpha = 1;

}

- (void)showPlayer {

    self.bgImageView.hidden = YES;
    self.bgImageView.alpha = 0;

}

- (void)scrollClosePlayer {

    if(self.bgImageView.hidden == YES) {
    
        [self closePlayer];
        
        ZSinglePlayerX *player = [ZSinglePlayerX shareInstance];
        [player setIsPlay:NO];
        [player closePlayer];
    
    }
    
}

@end
