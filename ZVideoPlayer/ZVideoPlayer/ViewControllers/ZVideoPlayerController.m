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
    
    UIButton *testbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [testbutton addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
    testbutton.frame = CGRectMake(20, 400, CGRectGetWidth(self.view.frame) - 40, 40);
    testbutton.backgroundColor = [UIColor redColor];
    [self.view addSubview:testbutton];

}

- (void)loadLayout {

    self.videoPlayerView.frame = CGRectMake(0, 120, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds) / 16.0 * 9.0);

}

- (void)testAction:(UIButton *)sedner {

    NSLog(@"------");
    self.videoPlayerView.frame = CGRectMake(0, 120, CGRectGetWidth(self.view.bounds) / 2.0, (CGRectGetWidth(self.view.bounds) / 16.0 * 9.0) / 2.0);

}

@end
