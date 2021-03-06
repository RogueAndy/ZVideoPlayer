//
//  ZVideoPlayerViewX.m
//  ZVideoPlayer
//
//  Created by rogue on 2017/5/11.
//  Copyright © 2017年 dazhongge. All rights reserved.
//

#import "ZVideoPlayerViewX.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ZVideoControlButton.h"
#import "ZVPangestureView.h"
#import "ZVVideoBackgroundController.h"
#import "RgScreenShot.h"
#import "ZVVideoBackgroundController.h"
#import "ZVVideoNavigationController.h"
#import "JPVideoPlayerResourceLoader.h"

@interface ZVTimeTransform : NSObject

+ (NSString *)secondTransformString:(CGFloat)time;

@end

@implementation ZVTimeTransform

+ (NSString *)secondTransformString:(CGFloat)time {

    NSInteger totalTime = (NSInteger)time;
    NSInteger minute = totalTime / 60;
    NSInteger second = totalTime % 60;

    NSString *minuteString = [NSString stringWithFormat:@"%ld", (long)minute];
    NSString *secondString = [NSString stringWithFormat:@"%ld", (long)second];
    if(minute < 10) {
    
        minuteString = [NSString stringWithFormat:@"0%ld", (long)minute];
        
    }
    
    if(second < 10) {
    
        secondString = [NSString stringWithFormat:@"0%ld", (long)second];
    
    }
    
    NSString *timeString = [NSString stringWithFormat:@"%@:%@", minuteString, secondString];
    
    return timeString;

}

@end








// 由于 slider 的值是根据视频的时间来设置，所以，时间循环调用 slider 自动滚动的间隔，也表示着每次间隔 slider 移动的距离
static CGFloat zvideo_timer_move_distanceX = 0.5;

@interface ZVideoPlayerViewX()

/**
 关闭按钮
 */
@property (nonatomic, strong) UIButton *closeButton;

/**
 显示当前播放的时长
 */
@property (nonatomic, strong) UILabel *currentTimeLabel;

/**
 显示整个视频的时长
 */
@property (nonatomic, strong) UILabel *totalTimeLabel;

/**
 视频控制按钮，包含了暂停和开始播放
 */
@property (nonatomic, strong) ZVideoControlButton *videoControlButton;

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
 自动隐藏工具栏的一个计时器，可以用于停止计时
 */
@property (nonatomic, strong) NSTimer *hideToolsTimer;

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
 判断是否是全屏的状态
 */
@property (nonatomic, assign) BOOL isFullScreen;

/**
 判断是否显示了工具栏
 */
@property (nonatomic, assign) BOOL isShowTools;

/**
 手势控制层，用于控制音量和亮度，必须在全屏状态下才有此手势，小屏没有手势效果，需要设置 ZVPangestureView.isLoadGesture 来启动或者禁止手势
 */
@property (nonatomic, strong) ZVPangestureView *pangestureView;

/**
 由于在全屏时候，需要取消状态栏，但是 view 是无法做到隐藏状态栏，还是需要引入一个 viewcontroller来控制状态栏额显示，所以全屏视频需要放在一个 viewcontroller 上
 */
@property (nonatomic, strong) ZVVideoBackgroundController *vvideoBackgroundController;

@property (nonatomic, strong) ZVVideoNavigationController *vvideoNavigationController;

@property (nonatomic, strong) AVURLAsset *videoUrlAsset;

@end

@implementation ZVideoPlayerViewX

#pragma mark - 初始化对象

+ (instancetype)initWithLocalVideo:(NSString *)filePath {
    
    NSAssert(filePath && filePath.length > 0, @"------------ filePath can't be nil or ''");
    ZVideoPlayerViewX *video = [[ZVideoPlayerViewX alloc] init];
    video.urlString = filePath;
    return video;
    
}

+ (instancetype)initWithOnlineVideo:(NSString *)fileUrl {
    
    NSAssert(fileUrl && fileUrl.length > 0, @"------------ fileUrl can't be nil or ''");
    ZVideoPlayerViewX *video = [[ZVideoPlayerViewX alloc] initWithFrame:CGRectZero];
    video.urlString = fileUrl;
    return video;
    
}

#pragma mark - 关闭播放器

- (void)closePlayer {

    [self closeAction:nil];

}

#pragma mark - 属性的 set get 方法(when urlString != nil(and not ''), it's time to init subViews)

- (void)showViewIn:(UIView *)superView animation:(BOOL)animation animationComplete:(void (^)(void))complete {
    
    if(!animation) {[superView addSubview:self];return;}
    
    self.alpha = 0;
    [superView addSubview:self];
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         if(complete) {
                         
                             complete();
                         
                         }
                         
                     }];
    
}

/**
 设置播放按钮，外部可控制播放暂停

 @param isPlay 布尔类型
 */
- (void)setIsPlay:(BOOL)isPlay {
    
    _isPlay = isPlay;
    if(_isPlay) {
        
        [self afterPlay];
        return;
    
    }
    
    [self afterStop];
    
}

/**
 设置地址，一旦设置了地址，那么所有的控件会在此重组，刷新播放界面，也是外部可控制的

 @param urlString 地址
 */
- (void)setUrlString:(NSString *)urlString {
    
    [self clearAll];
    
    _urlString = urlString;
    
    [self loadInit];
    [self loadViews];
    [self loadLayout];
    [self loadInitStatus];
}

/**
 懒加载 播放暂停按钮

 @return 按钮对象
 */
- (ZVideoControlButton *)videoControlButton {

    if(!_videoControlButton) {
    
        _videoControlButton = [ZVideoControlButton buttonWithType:UIButtonTypeCustom];
        [_videoControlButton setImage:[[UIImage imageNamed:@"player"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _videoControlButton.isplayer = NO;
        [_videoControlButton addTarget:self action:@selector(videoControlAction:) forControlEvents:UIControlEventTouchUpInside];
        _videoControlButton.frame = CGRectMake(0, 0, 80, 80);
        _videoControlButton.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0);
        [self addSubview:_videoControlButton];
    
    }
    
    return _videoControlButton;

}

#pragma mark - 构建界面以及布局(init some base datas and subViews)

- (void)loadInit {
    
    // 添加点击手势，用来控制工具栏的显示
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapVideo:)];
    [self addGestureRecognizer:tap];
    
}

- (void)loadViews {
    
    if([self.urlString hasPrefix:@"http"]) {
        
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
    
    self.currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.currentTimeLabel.textColor = [UIColor whiteColor];
    self.currentTimeLabel.font = [UIFont systemFontOfSize:12];
    self.currentTimeLabel.textAlignment = NSTextAlignmentRight;
    [self.bottomView addSubview:self.currentTimeLabel];
    
    self.slider = [[UISlider alloc] initWithFrame:CGRectZero];
    [self.slider setThumbImage:[UIImage imageNamed:@"movepoint"] forState:UIControlStateNormal];
    NSLog(@"jjjjjjjjjjjjjjjjjj");
    self.videoTotalTime = CMTimeGetSeconds(self.playerItem.asset.duration);
    NSLog(@"kkkkkkkkkkkkkkkkkk");
    self.slider.maximumValue = self.videoTotalTime;
    self.slider.continuous = YES;
    [self.slider addTarget:self action:@selector(sliderBegan:) forControlEvents:UIControlEventTouchDown];
    [self.slider addTarget:self action:@selector(sliderEnd:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.slider];
    
    self.totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.totalTimeLabel.textColor = [UIColor whiteColor];
    self.totalTimeLabel.font = [UIFont systemFontOfSize:12];
    self.totalTimeLabel.textAlignment = NSTextAlignmentLeft;
    [self.bottomView addSubview:self.totalTimeLabel];
    
    self.screenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.screenButton setImage:[UIImage imageNamed:@"screen"] forState:UIControlStateNormal];
    [self.screenButton addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.screenButton];
    
    /****************************************** 组装 bottomView 部分 ******************************************/
    
    self.totalTimeLabel.text = [ZVTimeTransform secondTransformString:self.videoTotalTime];
    
}

- (void)loadLayout {
    
    CGFloat blackViewHeight = CGRectGetHeight(self.bounds) / 6.0;
    self.playLayer.frame = self.bounds;
    self.videoControlButton.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0);
    
    /****************************************** 组装 topView 部分 ******************************************/
    
    self.topView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), blackViewHeight);
    self.closeButton.frame = CGRectMake(CGRectGetWidth(self.topView.frame) - 35, (CGRectGetHeight(self.topView.bounds) - CGRectGetHeight(self.topView.bounds) / 2.0) / 2.0, CGRectGetHeight(self.topView.bounds) / 2.0, CGRectGetHeight(self.topView.bounds) / 2.0);
    
    /****************************************** 组装 topView 部分 ******************************************/
    
    /****************************************** 组装 bottomView 部分 ******************************************/
    
    self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - blackViewHeight, CGRectGetWidth(self.bounds), blackViewHeight);
    self.slider.frame = CGRectMake(60, 10, CGRectGetWidth(self.bounds) - 160, CGRectGetHeight(self.bottomView.bounds) - 20);
    self.currentTimeLabel.frame = CGRectMake(10, self.slider.frame.origin.y, 45, self.slider.frame.size.height);
    self.totalTimeLabel.frame = CGRectMake(self.slider.frame.origin.x + self.slider.frame.size.width + 5, self.slider.frame.origin.y, 45, self.slider.frame.size.height);
    
    self.screenButton.frame = CGRectMake(self.totalTimeLabel.frame.origin.x + self.totalTimeLabel.frame.size.width + 10, (CGRectGetHeight(self.bottomView.bounds) - CGRectGetHeight(self.bottomView.bounds) / 2.0) / 2.0, CGRectGetHeight(self.bottomView.bounds) / 2.0, CGRectGetHeight(self.bottomView.bounds) / 2.0);
    
    /****************************************** 组装 bottomView 部分 ******************************************/
}

- (void)loadInitStatus {

    [self showTools];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self loadLayout];
    
}

#pragma mark - 在线视频生成代码(AVPlayerItem 用户获取视频信息，当前时间以及总时间)

- (void)loadOnlineVideo {
    
    NSURL *videoPathURL = [NSURL URLWithString:self.urlString];
    NSLog(@"1111111111111111");
    self.videoUrlAsset = [AVURLAsset URLAssetWithURL:videoPathURL options:nil];
    NSLog(@"2222222222222222");
    JPVideoPlayerResourceLoader *resourceLoader = [JPVideoPlayerResourceLoader new];
    [self.videoUrlAsset.resourceLoader setDelegate:resourceLoader queue:dispatch_get_main_queue()];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.videoUrlAsset];
    NSLog(@"3333333333333333");
    
    
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
//    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.urlString]];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    NSLog(@"4444444444444444");
    self.playLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    NSLog(@"5555555555555555");
    [self.layer addSublayer:self.playLayer];
    NSLog(@"6666666666666666");
    
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 2.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//        NSLog(@"------- %f", CMTimeGetSeconds(time));
    }];
    
    
    [self.player play];
    
    NSLog(@"9999999999999999");

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

/**
 点击全屏按钮响应，这里根据布尔类型控制当前状态是否是全屏，然后可以缩小放大

 @param sender nil
 */
- (void)fullScreenAction:(UIButton *)sender {
    
    if(self.isFullScreen) {
        
        [self fullScreenAndIsClose:NO];
        return;
        
    }
    
    [self unFullScreen];
    
}

/**
 时间条，可以拖动时间，开始准备拖动响应事件

 @param sender nil
 */
- (void)sliderBegan:(UISlider *)sender {
    
    [self.player pause];
    [self.sliderTimer invalidate];
    self.sliderTimer = nil;
    
    [self.hideToolsTimer invalidate];
    self.hideToolsTimer = nil;
    
}

/**
 时间条，可以拖动时间，拖动将会完成准备释放响应事件

 @param sender nil
 */
- (void)sliderEnd:(UISlider *)sender {
    
    [self.player seekToTime:CMTimeMake(self.slider.value, 1)];
    self.countSliderFloat = self.slider.value;
    self.hideToolsTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hideTools:) userInfo:nil repeats:NO];
    if(!self.videoControlButton.isplayer) {
        
        return;
        
    }
    self.sliderTimer = [NSTimer scheduledTimerWithTimeInterval:zvideo_timer_move_distanceX target:self selector:@selector(countSlider:) userInfo:nil repeats:YES];
    [self.player play];
    
}

#pragma mark - 计时器

/**
 每当界面的工具栏显示完全之后，设置固定时间，自动隐藏工具栏，为了更好的用户体验

 @param timer nil
 */
- (void)hideTools:(NSTimer *)timer {
    
    [self hideTools];
    
}

/**
 时间栏的控制，播放视频的当前时间显示

 @param timer nil
 */
- (void)countSlider:(NSTimer *)timer {
    
    if(self.countSliderFloat > self.videoTotalTime) {
        
        [self.sliderTimer invalidate];
        
        // 在自动播放完毕的时候，需要缩小屏幕，自动关闭播放界面
        [self closePlayer];
        return;
        
    }
    
    [self.slider setValue:self.countSliderFloat animated:YES];
    self.countSliderFloat += zvideo_timer_move_distanceX;
    self.currentTimeLabel.text = [ZVTimeTransform secondTransformString:self.countSliderFloat];
    
}

/**
 处于屏幕中间的按键，控制播放和暂停时间

 @param sender nil
 */
- (void)videoControlAction:(ZVideoControlButton *)sender {
    
    if(sender.isplayer) { // 正在播放，点击之后，停止播放，显示暂停按钮
        
        [self afterStop];
    
    } else { // 暂停播放或者还未播放，点击之后，开始播放视频
    
        [self afterPlay];
        
    }
    
}

/**
 点击屏幕，响应手势控制方法

 @param gesture 手势控制
 */
- (void)tapVideo:(UITapGestureRecognizer *)gesture {
    
    if(self.bottomView.hidden) {
        
        [self showTools];
        
        return;
        
    }
    
    [self hideTools];
    
}

/**
 点击关闭按钮响应时间，里面有关于 全屏和非全屏 的不同的响应界面控制方法

 @param sender nil
 */
- (void)closeAction:(UIButton *)sender {
    
    if(self.isFullScreen) { // 全屏情况下
    
        if(self.removeViewBlock) {
            
            [self afterStop]; // 停止时间条控制
            [self fullScreenAndIsClose:YES];
        }
        return;
    
    }
    
    if(self.removeViewBlock) { // 非全屏情况下
        
        [self afterStop]; // 停止时间条控制
        self.removeViewBlock();
    
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                             self.alpha = 1;
                             [self clearAll];
                         }];
        
    }
    
}

#pragma mark - 点击暂停之后的变化

/**
 点击暂停之后的界面变化
 */
- (void)afterStop {

    self.videoControlButton.isplayer = NO;
    [self.player pause];
    [self.sliderTimer invalidate];
    self.sliderTimer = nil;
    [self.videoControlButton setImage:[[UIImage imageNamed:@"player"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
}

#pragma mark - 点击继续播放之后的变化

/**
 点击播放之后的界面变化
 */
- (void)afterPlay {

    self.videoControlButton.isplayer = YES;
    NSLog(@"777777777777777");
    [self.player play];
    NSLog(@"888888888888888");
    self.sliderTimer = [NSTimer scheduledTimerWithTimeInterval:zvideo_timer_move_distanceX target:self selector:@selector(countSlider:) userInfo:nil repeats:YES];
    [self.videoControlButton setImage:[[UIImage imageNamed:@"pause"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
}

#pragma mark - 全屏和非全屏的控制

/**
 该方法是用于，当视频处于小界面，需要被放大时候使用
 */
- (void)unFullScreen {
    
    self.vvideoBackgroundController = [ZVVideoBackgroundController initWithBackgroundImage:[RgScreenShot imageWithViewController:self.superViewController]];
    self.vvideoNavigationController = [[ZVVideoNavigationController alloc] initWithRootViewController:self.vvideoBackgroundController];
    
    [self.superViewController presentViewController:self.vvideoNavigationController animated:NO completion:^{
       
        self.beforeFrame = self.frame;
        
        self.willFullScreenBlock();
        self.pangestureView = [[ZVPangestureView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.pangestureView.backgroundColor = [UIColor clearColor];
        [self.vvideoBackgroundController.view addSubview:self.pangestureView];
        self.pangestureView.isLoadGesture = YES;
        [self.pangestureView addSubview:self];
        
        // 由于在进入 ZVVideoBackgroundController 会使手机进入横屏状态，所以坐标轴反转
        CGAffineTransform form = CGAffineTransformMakeRotation(-M_PI * 0.5);
        [self setTransform:form];

        CGRect cellRectInSuperView = self.returnCellRectInSuperView();
        self.frame = CGRectMake( cellRectInSuperView.origin.y + 64, cellRectInSuperView.origin.x, cellRectInSuperView.size.height, cellRectInSuperView.size.width);

        [UIView animateWithDuration:0.25
                         animations:^{
                             [self setTransform:CGAffineTransformIdentity];
                             self.frame = [[UIScreen mainScreen] bounds];
                         }
                         completion:^(BOOL finished) {
                             [self.screenButton setImage:[UIImage imageNamed:@"scale"] forState:UIControlStateNormal];
                             self.isFullScreen = YES;
                             [self setTransform:CGAffineTransformIdentity];
                         }];
        
    }];

}




/**
 该方法用于，当界面是全屏的时候，需要缩小或者被关闭还原

 @param is 是否被关闭，YES为关闭
 */
- (void)fullScreenAndIsClose:(BOOL)is {
    
    if(is) {

        [self closeThePlayer];
        return;
    
    }

    [self scaleThePlayer];
    
}

- (void)closeThePlayer {

    [self.pangestureView removeFromSuperview];
    self.pangestureView = nil;
    [self.vvideoNavigationController dismissViewControllerAnimated:NO completion:^{
        CGAffineTransform form = CGAffineTransformMakeRotation(M_PI * 0.5);
        [self setTransform:form];
        self.frame = [[UIScreen mainScreen] bounds];
        [self.superViewController.view addSubview:self];
        
        self.removeViewBlock();
        [UIView animateWithDuration:0.25
                         animations:^{
                             
                             // 由于再放大的时候，进行了一个旋转，所以这里需要还原视图，还需要再次旋转
                             CGAffineTransform form = CGAffineTransformIdentity;
                             [self setTransform:form];
                             CGRect cellRectInSuperView = self.returnCellRectInSuperView();
                             self.frame = CGRectMake(cellRectInSuperView.origin.x, cellRectInSuperView.origin.y + 64, CGRectGetWidth(cellRectInSuperView), CGRectGetHeight(cellRectInSuperView));
                             self.alpha = 0;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             [self.screenButton setImage:[UIImage imageNamed:@"screen"] forState:UIControlStateNormal];
                             self.isFullScreen = NO;
                             [self removeFromSuperview];
                             self.alpha = 1;
                             [self clearAll];
                             
                         }];
    }];

}

- (void)scaleThePlayer {

    [self.pangestureView removeFromSuperview];
    self.pangestureView = nil;
    
    [self.vvideoBackgroundController dismissViewControllerAnimated:NO completion:^{
        
        CGAffineTransform form = CGAffineTransformMakeRotation(M_PI * 0.5);
        [self setTransform:form];
        self.frame = [[UIScreen mainScreen] bounds];
        [self.superViewController.view addSubview:self];
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             
                             // 由于再放大的时候，进行了一个旋转，所以这里需要还原视图，还需要再次旋转
                             CGAffineTransform form = CGAffineTransformIdentity;
                             [self setTransform:form];
                             CGRect cellRectInSuperView = self.returnCellRectInSuperView();
                             self.frame = CGRectMake(cellRectInSuperView.origin.x, cellRectInSuperView.origin.y + 64, CGRectGetWidth(cellRectInSuperView), CGRectGetHeight(cellRectInSuperView));
                             
                         }
                         completion:^(BOOL finished) {
                             
                             [self.screenButton setImage:[UIImage imageNamed:@"screen"] forState:UIControlStateNormal];
                             self.isFullScreen = NO;
                             [self setTransform:CGAffineTransformIdentity];
                             self.frame = self.beforeFrame;
                             self.willUnFullScreenBlock();
                             self.vvideoBackgroundController = nil;
                             self.vvideoNavigationController = nil;
                             
                         }];
        
    }];
    
}

#pragma mark - 控制工具栏

/**
 点击视频显示工具栏
 */
- (void)showTools {

    self.bottomView.hidden = NO;
    self.topView.hidden = NO;
    self.videoControlButton.hidden = NO;
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.bottomView.alpha = 1;
                         self.topView.alpha = 1;
                         self.videoControlButton.alpha = 1;
                         self.isShowTools = YES;
                         
                         self.hideToolsTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hideTools:) userInfo:nil repeats:NO];
                     }];

}

/**
 点击视频关闭工具栏
 */
- (void)hideTools {

    [UIView animateWithDuration:0.25
                     animations:^{
                         self.bottomView.alpha = 0;
                         self.topView.alpha = 0;
                         self.videoControlButton.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         self.bottomView.hidden = YES;
                         self.topView.hidden = YES;
                         self.videoControlButton.hidden = YES;
                         self.isShowTools = NO;
                         [self.hideToolsTimer invalidate];
                         self.hideToolsTimer = nil;
                     }];

}

/**
 每次视频不需要使用的时候，清楚界面，释放内存空间
 */
- (void)clearAll {

    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    
    [self.player pause];
    [self.player cancelPendingPrerolls];
    self.player = nil;
    [self.videoUrlAsset.resourceLoader setDelegate:nil queue:dispatch_get_main_queue()];
    
    [self.closeButton removeFromSuperview];
    [self.currentTimeLabel removeFromSuperview];
    [self.totalTimeLabel removeFromSuperview];
    [self.videoControlButton removeFromSuperview];
    [self.screenButton removeFromSuperview];
    [self.playLayer removeFromSuperlayer];
    [self.bottomView removeFromSuperview];
    [self.topView removeFromSuperview];
    [self.slider removeFromSuperview];
    
    [self.sliderTimer invalidate];
    [self.hideToolsTimer invalidate];
    
    self.closeButton = nil;
    self.currentTimeLabel = nil;
    self.totalTimeLabel = nil;
    self.videoControlButton = nil;
    self.screenButton = nil;
    self.playerItem = nil;
    self.player = nil;
    self.playLayer = nil;
    self.bottomView = nil;
    self.topView = nil;
    self.slider = nil;
    self.sliderTimer = nil;
    self.hideToolsTimer = nil;
    self.countSliderFloat = 0;
    self.videoTotalTime = 0;
    self.beforeFrame = CGRectZero;
    self.superViewController = nil;
    self.vvideoBackgroundController = nil;
    self.vvideoNavigationController = nil;

}

#pragma mark - KVC

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    if([keyPath isEqualToString:@"loadedTimeRanges"]) {
    
//        NSLog(@"dwadaw");
    
    } else if([keyPath isEqualToString:@"status"])
    {
    
//        NSLog(@"----- 状态");
    
    }
}

@end
