//
//  ZVideoPlayerView.m
//  ZVideoPlayer
//
//  Created by dazhongge on 2016/12/29.
//  Copyright © 2016年 dazhongge. All rights reserved.
//

#import "ZVideoPlayerView.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

// 由于 slider 的值是根据视频的时间来设置，所以，时间循环调用 slider 自动滚动的间隔，也表示着每次间隔 slider 移动的距离
static CGFloat zvideo_timer_move_distance = 0.5;

@interface ZVideoPlayerView()

/**
 关闭按钮
 */
@property (nonatomic, strong) UIButton *closeButton;

/**
 播放按钮放在中间位置
 */
@property (nonatomic, strong) UIButton *playButton;

/**
 暂停按钮
 */
@property (nonatomic, strong) UIButton *stopButton;

/**
 展开或者缩小全屏按钮
 */
@property (nonatomic, strong) UIButton *screenButton;

/**
 获取视频信息，当前时间以及总时间之类的信息
 */
@property (nonatomic, strong) AVPlayerItem *playerItem;

/**
 视频播放对象
 */
@property (nonatomic, strong) AVPlayer *player;

/**
 视频播放对象所在的layer层
 */
@property (nonatomic, strong) AVPlayerLayer *playLayer;

/**
 视频地址
 */
@property (nonatomic, strong) NSString *urlString;

/**
 底部的透明层
 */
@property (nonatomic, strong) UIView *bottomView;

/**
 顶部的透明层
 */
@property (nonatomic, strong) UIView *topView;

/**
 滑动条
 */
@property (nonatomic, strong) UISlider *slider;

/**
 根据视频的时间设置自动跟新 slider 值的一个定时器
 */
@property (nonatomic, strong) NSTimer *sliderTimer;

/**
 累计叠加 slider 的当前的value值，用于计算 slider 已经滑动的长度
 */
@property (nonatomic) CGFloat countSliderFloat;

/**
 计算视频的总时间
 */
@property (nonatomic) CGFloat videoTotalTime;

/**
 记录 view 上次的 frame
 */
@property (nonatomic) CGRect beforeFrame;

/**
 判断 继续播放按钮是否存在，根据此 布尔类型来判断点击手势是否成立
 */
@property (nonatomic, assign) BOOL isPlayButton;

/**
 判断是否是全屏的状态
 */
@property (nonatomic, assign) BOOL isFullScreen;

@end

@implementation ZVideoPlayerView

#pragma mark - 初始化对象

+ (instancetype)initWithLocalVideo:(NSString *)filePath {

    NSAssert(filePath && filePath.length > 0, @"------------ filePath can't be nil or ''");
    ZVideoPlayerView *video = [[ZVideoPlayerView alloc] init];
    video.urlString = filePath;
    return video;

}

+ (instancetype)initWithOnlineVideo:(NSString *)fileUrl {

    NSAssert(fileUrl && fileUrl.length > 0, @"------------ fileUrl can't be nil or ''");
    ZVideoPlayerView *video = [[ZVideoPlayerView alloc] initWithFrame:CGRectZero];
    video.urlString = fileUrl;
    return video;

}

#pragma mark - 属性的 set get 方法(when urlString != nil(and not ''), it's time to init subViews)

- (void)showViewIn:(UIView *)superView animation:(BOOL)animation {

    if(!animation) {[superView addSubview:self];return;}
    
    self.alpha = 0;
    [superView addSubview:self];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = 1;
                     }];

}

- (void)setIsPlay:(BOOL)isPlay {

    _isPlay = isPlay;
    if(_isPlay){[self.player play];return;}
    [self.player pause];

}

- (void)setUrlString:(NSString *)urlString {

    _urlString = urlString;
    
    [self loadInit];
    [self loadViews];
    [self loadLayout];
    [self loadInitStatus];
}

- (UIButton *)playButton {

    if(!_playButton) {
    
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[[UIImage imageNamed:@"player"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(replayAction:) forControlEvents:UIControlEventTouchUpInside];
        _playButton.frame = CGRectMake(0, 0, 80, 80);
        _playButton.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0);
        self.isPlayButton = YES;
        [self addSubview:_playButton];
    
    }
    
    return _playButton;

}

#pragma mark - 构建界面以及布局(init some base datas and subViews)

- (void)loadInit {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapVideo:)];
    [self addGestureRecognizer:tap];

}

- (void)loadViews {

    if([self.urlString hasSuffix:@"http"]) {
    
        [self loadOnlineVideo];
        
    } else {
    
        [self loadLocalVideo];
    
    }
    
    /****************************************** 组装 topView 部分 ******************************************/
    
    self.topView = [[UIView alloc] initWithFrame:CGRectZero];
    self.topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.topView.userInteractionEnabled = YES;
    [self addSubview:self.topView];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.closeButton];
    
    /****************************************** 组装 topView 部分 ******************************************/
    
    /****************************************** 组装 bottomView 部分 ******************************************/
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.bottomView.userInteractionEnabled = YES;
    [self addSubview:self.bottomView];
    
    self.slider = [[UISlider alloc] initWithFrame:CGRectZero];
    [self.slider setThumbImage:[UIImage imageNamed:@"movepoint"] forState:UIControlStateNormal];
    self.videoTotalTime = CMTimeGetSeconds(self.playerItem.asset.duration);
    self.slider.maximumValue = self.videoTotalTime;
    self.slider.continuous = YES;
    [self.slider addTarget:self action:@selector(sliderBegan:) forControlEvents:UIControlEventTouchDown];
    [self.slider addTarget:self action:@selector(sliderEnd:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.slider];
    
    self.stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.stopButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [self.stopButton addTarget:self action:@selector(stopAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.stopButton];
    
    self.screenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.screenButton setImage:[UIImage imageNamed:@"screen"] forState:UIControlStateNormal];
    [self.screenButton addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.screenButton];
    
    /****************************************** 组装 bottomView 部分 ******************************************/
    
}

- (void)loadLayout {

    CGFloat blackViewHeight = CGRectGetHeight(self.bounds) / 6.0;
    self.playLayer.frame = self.bounds;
    _playButton.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0);
    
    /****************************************** 组装 topView 部分 ******************************************/
    
    self.topView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), blackViewHeight);
    self.closeButton.frame = CGRectMake(CGRectGetWidth(self.topView.frame) - 35, (CGRectGetHeight(self.topView.bounds) - CGRectGetHeight(self.topView.bounds) / 2.0) / 2.0, CGRectGetHeight(self.topView.bounds) / 2.0, CGRectGetHeight(self.topView.bounds) / 2.0);
    
    /****************************************** 组装 topView 部分 ******************************************/
    
    /****************************************** 组装 bottomView 部分 ******************************************/
    
    self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - blackViewHeight, CGRectGetWidth(self.bounds), blackViewHeight);
    self.slider.frame = CGRectMake(40, 10, CGRectGetWidth(self.bounds) - 80, CGRectGetHeight(self.bottomView.bounds) - 20);
    self.stopButton.frame = CGRectMake((40 - CGRectGetHeight(self.bottomView.bounds) / 2.0) / 2.0, (CGRectGetHeight(self.bottomView.bounds) - CGRectGetHeight(self.bottomView.bounds) / 2.0) / 2.0, CGRectGetHeight(self.bottomView.bounds) / 2.0, CGRectGetHeight(self.bottomView.bounds) / 2.0);
    self.screenButton.frame = CGRectMake(self.slider.frame.origin.x + self.slider.frame.size.width + 5, (CGRectGetHeight(self.bottomView.bounds) - CGRectGetHeight(self.bottomView.bounds) / 2.0) / 2.0, CGRectGetHeight(self.bottomView.bounds) / 2.0, CGRectGetHeight(self.bottomView.bounds) / 2.0);
    
    /****************************************** 组装 bottomView 部分 ******************************************/

}

- (void)loadInitStatus {

    self.bottomView.alpha = 0;
    self.topView.alpha = 0;
    self.playButton.alpha = 1;
    self.bottomView.hidden = YES;
    self.topView.hidden = YES;
    self.playButton.hidden = NO;
    self.isPlayButton = YES;
}

- (void)layoutSubviews {

    [super layoutSubviews];
    [self loadLayout];

}

#pragma mark - 在线视频生成代码(AVPlayerItem 用户获取视频信息，当前时间以及总时间)

- (void)loadOnlineVideo {

    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.urlString]];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.layer addSublayer:self.playLayer];

}

#pragma mark - 本地视频生成代码

- (void)loadLocalVideo {

    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:self.urlString] options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.layer addSublayer:self.playLayer];

}

#pragma mark - selector action

- (void)fullScreenAction:(UIButton *)sender {

    if(self.isFullScreen) {
    
        [UIView animateWithDuration:0.25
                         animations:^{
                             [self setTransform:CGAffineTransformIdentity];
                             self.frame = self.beforeFrame;
                         }
                         completion:^(BOOL finished) {
                             [self.screenButton setImage:[UIImage imageNamed:@"screen"] forState:UIControlStateNormal];
                             self.isFullScreen = NO;
                         }];
        
        
        return;
    
    }
    
    self.beforeFrame = self.frame;

    [UIView animateWithDuration:0.25
                     animations:^{
                         [self setTransform:CGAffineTransformMakeRotation(M_PI_2)];
                         self.frame = [[UIScreen mainScreen] bounds];
                     }
                     completion:^(BOOL finished) {
                         [self.screenButton setImage:[UIImage imageNamed:@"scale"] forState:UIControlStateNormal];
                         self.isFullScreen = YES;
                     }];

}

- (void)sliderBegan:(UISlider *)sender {

    [self.player pause];
    [self.sliderTimer invalidate];
    self.sliderTimer = nil;
    
}

- (void)sliderEnd:(UISlider *)sender {

    [self.player seekToTime:CMTimeMake(self.slider.value, 1)];
    self.countSliderFloat = self.slider.value;
    if(self.isPlayButton) {
    
        return;
    
    }
    self.sliderTimer = [NSTimer scheduledTimerWithTimeInterval:zvideo_timer_move_distance target:self selector:@selector(countSlider:) userInfo:nil repeats:YES];
    [self.player play];
    
}

- (void)countSlider:(NSTimer *)timer {

    if(self.countSliderFloat > self.videoTotalTime) {
    
        [self.sliderTimer invalidate];
        return;
    
    }
    
    [self.slider setValue:self.countSliderFloat animated:YES];
    self.countSliderFloat += zvideo_timer_move_distance;

}

- (void)stopAction:(UIButton *)sender {

    [self.player pause];
    [self.sliderTimer invalidate];
    self.sliderTimer = nil;
    [self afterStop];

}

- (void)replayAction:(UIButton *)sender {

    [self.player play];
    self.sliderTimer = [NSTimer scheduledTimerWithTimeInterval:zvideo_timer_move_distance target:self selector:@selector(countSlider:) userInfo:nil repeats:YES];
    [self afterPlay];
    
}

- (void)tapVideo:(UITapGestureRecognizer *)gesture {

    if(self.isPlayButton) {
    
        return;
    
    }
    
    if(self.bottomView.hidden) {
    
        self.bottomView.hidden = NO;
        self.topView.hidden = NO;
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.bottomView.alpha = 1;
                             self.topView.alpha = 1;
                         }];
        
        return;
    
    }
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.bottomView.alpha = 0;
                         self.topView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         self.bottomView.hidden = YES;
                         self.topView.hidden = YES;
                     }];

}

- (void)closeAction:(UIButton *)sender {

    if(self.removeViewBlock) {
    
        self.removeViewBlock();
    
    }
    
}

#pragma mark - 点击暂停之后的变化

- (void)afterStop {

    self.playButton.alpha = 0;
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.playButton.alpha = 1;
                     }];

}

#pragma mark - 点击继续播放之后的变化

- (void)afterPlay {

    [UIView animateWithDuration:0.25
                     animations:^{
                         self.playButton.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.playButton removeFromSuperview];
                         self.playButton = nil;
                         self.isPlayButton = NO;
                     }];

}

@end
