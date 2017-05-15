//
//  ZVideoPlayerViewControllerX.m
//  ZVideoPlayer
//
//  Created by rogue on 2017/5/11.
//  Copyright © 2017年 dazhongge. All rights reserved.
//

#import "ZVideoPlayerViewControllerX.h"
#import "ZVideoPlayerViewX.h"

@interface ZVideoPlayerViewControllerX ()

@property (nonatomic, strong) ZVideoPlayerViewX *videoPlayerViewX;

@end

@implementation ZVideoPlayerViewControllerX

- (void)loadViews {
    
    UIButton *show = [UIButton buttonWithType:UIButtonTypeCustom];
    [show addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    show.backgroundColor = [UIColor orangeColor];
    show.frame = CGRectMake(20, 140, CGRectGetWidth(self.view.frame) - 40, 40);
    [self.view addSubview:show];
    
}

- (void)loadLayout {
    
    self.videoPlayerViewX.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds) / 16.0 * 8.0);
    
}

- (void)show {

    self.videoPlayerViewX = [ZVideoPlayerViewX initWithOnlineVideo:@"http://live.cqnews.net/data/video/201705/10/2c24c05b-455b-4348-f6b9-1ab748168e87/transcode_9c44fac4-6bf7-8c9f-9b15-7e9fddc2.mp4"];
    self.videoPlayerViewX.backgroundColor = [UIColor blackColor];
    
    __weak ZVideoPlayerViewControllerX *weakSelf = self;
    self.videoPlayerViewX.removeViewBlock = ^{
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             weakSelf.videoPlayerViewX.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [weakSelf.videoPlayerViewX removeFromSuperview];
                             weakSelf.videoPlayerViewX = nil;
                         }];
        
    };
    
    [self.videoPlayerViewX showViewIn:self.navigationController.view animation:YES animationComplete:nil];
    
    [self loadLayout];
    
    self.videoPlayerViewX.isPlay = YES;

}

@end
