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
 展开全屏按钮
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

@end

@implementation ZVideoPlayerView

#pragma mark - 初始化对象

+ (instancetype)initWithLocalVideo:(NSString *)filePath {

    ZVideoPlayerView *video = [[ZVideoPlayerView alloc] init];
    video.urlString = filePath;
    return video;

}

+ (instancetype)initWithOnlineVideo:(NSString *)fileUrl {

    ZVideoPlayerView *video = [[ZVideoPlayerView alloc] initWithFrame:CGRectZero];
    video.urlString = fileUrl;
    return video;

}

#pragma mark - 属性的 set 方法

- (void)setUrlString:(NSString *)urlString {

    _urlString = urlString;
    if(!self.urlString || self.urlString.length == 0) {
        
        return;
        
    }
    
    // 当地址有了值之后，进行界面的初始化
    [self loadInit];
    [self loadViews];
    [self loadLayout];

}

#pragma mark - 构建界面

- (void)loadInit {

    [super loadInit];
    if(!self.urlString || self.urlString.length == 0) {
        
        return;
        
    }

}

- (void)loadViews {
    
    [super loadViews];
    if(!self.urlString || self.urlString.length == 0) {
    
        return;
    
    }
    if([self.urlString hasSuffix:@"http"]) {
    
        [self loadOnlineVideo];
        
    } else {
    
        [self loadLocalVideo];
    
    }
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.bottomView.userInteractionEnabled = YES;
    [self addSubview:self.bottomView];
    
    self.topView = [[UIView alloc] initWithFrame:CGRectZero];
    self.topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.topView.userInteractionEnabled = YES;
    [self addSubview:self.topView];
    
    self.slider = [[UISlider alloc] initWithFrame:CGRectZero];
    [self.slider setThumbImage:[UIImage imageNamed:@"movepoint"] forState:UIControlStateNormal];
    [self.bottomView addSubview:self.slider];
    
}

- (void)loadLayout {

    [super loadLayout];
    if(!self.urlString || self.urlString.length == 0) {
        
        return;
        
    }
    self.playLayer.frame = self.bounds;
    
    CGFloat blackViewHeight = CGRectGetHeight(self.bounds) / 6.0;
    self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - blackViewHeight, CGRectGetWidth(self.bounds), blackViewHeight);
    self.topView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), blackViewHeight);
    self.slider.frame = CGRectMake(20, 10, CGRectGetWidth(self.bounds) - 40, CGRectGetHeight(self.bottomView.bounds) - 20);

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
    
    [self.player play];

}

#pragma mark - 本地视频生成代码

- (void)loadLocalVideo {

    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:self.urlString] options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.layer addSublayer:self.playLayer];
    
    [self.player play];

}

@end
