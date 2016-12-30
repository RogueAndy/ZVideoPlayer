//
//  ZVideoPlayerController.m
//  ZVideoPlayer
//
//  Created by dazhongge on 2016/12/29.
//  Copyright © 2016年 dazhongge. All rights reserved.
//

#import "ZVideoPlayerController.h"
#import "ZVideoPlayerView.h"

@interface ZVideoPlayerController ()

@property (nonatomic, strong) ZVideoPlayerView *videoPlayerView;

@end

@implementation ZVideoPlayerController

- (void)loadViews {

    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"ceshivideo" ofType:@"mov"];
    self.videoPlayerView = [ZVideoPlayerView initWithLocalVideo:videoPath];
    self.videoPlayerView.backgroundColor = [UIColor blackColor];
    [self.navigationController.view addSubview:self.videoPlayerView];
    
    __weak ZVideoPlayerController *weakSelf = self;
    self.videoPlayerView.removeViewBlock = ^{
    
        [UIView animateWithDuration:0.25
                         animations:^{
                             weakSelf.videoPlayerView.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [weakSelf.videoPlayerView removeFromSuperview];
                             weakSelf.videoPlayerView = nil;
                         }];
        
    };
    
    UIButton *test = [UIButton buttonWithType:UIButtonTypeCustom];
    [test addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
    test.backgroundColor = [UIColor yellowColor];
    test.frame = CGRectMake(20, 300, CGRectGetWidth(self.view.frame) - 40, 40);
    [self.view addSubview:test];
    

}

- (void)loadLayout {

    self.videoPlayerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds) / 16.0 * 8.0);

}

- (void)testAction:(UIButton *)sender {

    NSLog(@"-----  %@", self.videoPlayerView);

}

@end
