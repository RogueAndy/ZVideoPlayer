//
//  ZVideoPlayerController.m
//  ZVideoPlayer
//
//  Created by dazhongge on 2016/12/29.
//  Copyright © 2016年 dazhongge. All rights reserved.
//

#import "ZVideoPlayerController.h"
#import "ZVideoPlayerView.h"
#import "ZVideoListViewController.h"
#import "ZVideoPlayerViewControllerX.h"

@interface ZVideoPlayerController ()

@property (nonatomic, strong) ZVideoPlayerView *videoPlayerView;

@end

@implementation ZVideoPlayerController

- (void)loadViews {
    
    UIButton *push = [UIButton buttonWithType:UIButtonTypeCustom];
    [push addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    push.backgroundColor = [UIColor orangeColor];
    push.frame = CGRectMake(20, 100, CGRectGetWidth(self.view.frame) - 40, 40);
    [self.view addSubview:push];
    
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
//    UIButton *showView = [UIButton buttonWithType:UIButtonTypeCustom];
//    [showView addTarget:self action:@selector(showAction:) forControlEvents:UIControlEventTouchUpInside];
//    showView.backgroundColor = [UIColor yellowColor];
//    showView.frame = CGRectMake(20, 100, CGRectGetWidth(self.view.frame) - 40, 40);
//    [self.view addSubview:showView];
//    
//    UIButton *test = [UIButton buttonWithType:UIButtonTypeCustom];
//    [test addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
//    test.backgroundColor = [UIColor yellowColor];
//    test.frame = CGRectMake(20, 300, CGRectGetWidth(self.view.frame) - 40, 40);
//    [self.view addSubview:test];

}

- (void)loadLayout {

    self.videoPlayerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds) / 16.0 * 8.0);

}

- (void)showAction:(UIButton *)sender {

//    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"ceshivideo" ofType:@"mov"];
//    self.videoPlayerView = [ZVideoPlayerView initWithLocalVideo:videoPath];
    self.videoPlayerView = [ZVideoPlayerView initWithOnlineVideo:@"http://live.cqnews.net/data/video/201705/10/2c24c05b-455b-4348-f6b9-1ab748168e87/transcode_9c44fac4-6bf7-8c9f-9b15-7e9fddc2.mp4"];
    self.videoPlayerView.backgroundColor = [UIColor blackColor];
    
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
    
    [self.videoPlayerView showViewIn:self.navigationController.view animation:YES];
    
    [self loadLayout];

}

- (void)testAction:(UIButton *)sender {

    NSLog(@"-----  %@", self.videoPlayerView);

}

- (void)pushAction:(UIButton *)sender {

    ZVideoListViewController *vc = [ZVideoListViewController new];
    [self.navigationController pushViewController:vc animated:YES];

}

@end
