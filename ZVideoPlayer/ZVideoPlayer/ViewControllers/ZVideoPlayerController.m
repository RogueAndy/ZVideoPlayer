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
    [self.view addSubview:self.videoPlayerView];

}

- (void)loadLayout {

    self.videoPlayerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds) / 16.0 * 8.0);

}

- (void)viewWillLayoutSubviews {

    [super viewWillLayoutSubviews];
    [self loadLayout];

}

@end
