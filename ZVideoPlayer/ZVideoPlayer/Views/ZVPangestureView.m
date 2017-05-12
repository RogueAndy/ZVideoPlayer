//
//  ZVPangestureView.m
//  ZVideoPlayer
//
//  Created by rogue on 2017/5/12.
//  Copyright © 2017年 dazhongge. All rights reserved.
//

#import "ZVPangestureView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, ZVPanControlVideo) {

    ZVPanLight  = 0,
    ZVPanVolume = 1

};

@interface ZVPangestureView()

@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@property (nonatomic) ZVPanControlVideo lightOrVlolume;

@property (nonatomic, assign) BOOL isBeginTouch;

@property (nonatomic) CGPoint recordTouchLocationInView;

@property (nonatomic, strong) MPVolumeView *volumeView;

@property (nonatomic, strong) UISlider *volumeViewSlider;

/**
 开始亮度
 */
@property (nonatomic) CGFloat startLight;

@property (nonatomic) CGFloat startVolume;

@end

@implementation ZVPangestureView

- (instancetype)initWithFrame:(CGRect)frame {

    if(self = [super initWithFrame:frame]) {
    
        [self loadViews];
        
    }
    
    return self;

}

- (void)dealloc {

    NSLog(@"------------------ %@ has dealloc!!!", [self class]);

}

- (MPVolumeView *)volumeView {
    if (_volumeView == nil) {
        _volumeView  = [[MPVolumeView alloc] init];
        [_volumeView sizeToFit];
        for (UIView *view in [_volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                self.volumeViewSlider = (UISlider*)view;
                break;
            }
        }
    }
    return _volumeView;
}

#pragma mark - 是否启动手势

- (void)setIsLoadGesture:(BOOL)isLoadGesture {

    self.startLight = [[UIScreen mainScreen] brightness];
    _isLoadGesture = isLoadGesture;
    self.userInteractionEnabled = _isLoadGesture;

}

#pragma mark - method

- (void)loadViews {
    
    // 如果是静音模式，需要打开外扩音
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];

    // 添加手势
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self addGestureRecognizer:self.pan];
    
    // 添加音量控件
    self.volumeView.frame = CGRectZero;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeKey:)
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];

}

- (void)panGesture:(UIPanGestureRecognizer *)gesture {

    CGPoint panStartPoint = [gesture translationInView:self];

    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
        
            self.isBeginTouch = YES;
            self.lightOrVlolume = CGRectGetHeight([[UIScreen mainScreen] bounds]) / 2.0 > self.recordTouchLocationInView.x ? ZVPanLight : ZVPanVolume;
        
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
        
            switch (self.lightOrVlolume) {
                case ZVPanLight:
                {
                
                    if(panStartPoint.x > 0) {
                    
                        [[UIScreen mainScreen] setBrightness:self.startLight + (panStartPoint.x / 30.0 / 10)];
                    
                    } else {
                    
                        [[UIScreen mainScreen] setBrightness:self.startLight - (-panStartPoint.x / 30.0 / 10)];
                    
                    }
                    
                    NSLog(@"调整亮度中... %f", [[UIScreen mainScreen] brightness]);
                
                }
                    break;
                case ZVPanVolume:
                {
                
                    if (panStartPoint.x > 0) {
                        
                        [self.volumeViewSlider setValue:self.startVolume + (panStartPoint.x / 100.0 / 10) animated:YES];

                    } else {
                        
                        [self.volumeViewSlider setValue:self.startVolume - (-panStartPoint.x / 100.0 / 10) animated:YES];
                    
                    }
                    
                    NSLog(@"调整声音中...   %f", self.volumeViewSlider.value);
                
                }
                    break;
            }
        
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
        
            self.isBeginTouch = NO;
            self.startLight = [[UIScreen mainScreen] brightness];
            self.startVolume = self.volumeViewSlider.value;
        
        }
            break;
        default:
            break;
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    CGPoint point = [touch locationInView:[touch view]];
    self.recordTouchLocationInView = point;

}

#pragma mark - 一些监听音量的方法

- (void)volumeKey:(NSNotification *)notification {

    NSDictionary *userinfo = notification.userInfo;
    self.startVolume = [userinfo[@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];

}

@end
