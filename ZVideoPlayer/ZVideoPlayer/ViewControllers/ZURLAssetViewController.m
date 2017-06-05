//
//  ZURLAssetViewController.m
//  ZVideoPlayer
//
//  Created by rogue on 2017/5/26.
//  Copyright © 2017年 dazhongge. All rights reserved.
//

#import "ZURLAssetViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"
#import "ZURLAssetCell.h"

@interface ZURLAssetViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) AVAsset *asset;

@property (nonatomic, strong) AVURLAsset *urlAsset;

@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, strong) NSMutableArray *urls;

@property (nonatomic, strong) NSMutableArray *imageurls;

@property (nonatomic) NSInteger urls_index;

@property (nonatomic, strong) UIScrollView *bgScroll;

@property (nonatomic, strong) UITableView *table;

@end

@implementation ZURLAssetViewController

- (UIScrollView *)bgScroll {

    if(!_bgScroll) {
    
        _bgScroll = [[UIScrollView alloc] init];
        _bgScroll.backgroundColor = [UIColor orangeColor];
        _bgScroll.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        _bgScroll.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), 1000);
        [self.view addSubview:_bgScroll];
    
    }
    
    return _bgScroll;

}

- (NSMutableArray *)imageurls {

    if(!_imageurls) {

        _imageurls = [NSMutableArray arrayWithObjects:@"http://i.cqnews.net/cbg/attachement/png/site1/20170510/000b0e0f00ed1a7d6a4111.png",
                      @"http://i.cqnews.net/cbg/attachement/png/site1/20170510/000b0e0f00ed1a7d68990e.png",
                      @"http://i.cqnews.net/cbg/attachement/jpg/site1/20170510/000b0e0f00ed1a7d5b0c63.jpg",
                      @"http://i.cqnews.net/cbg/attachement/jpg/site1/20170510/000b0e0f00ed1a7d57ca60.jpg",
                      @"http://i.cqnews.net/cbg/attachement/png/site1/20170514/00ea0114a5c11a827b0648.png",
                      @"http://i.cqnews.net/cbg/attachement/jpg/site1/20170514/00ea0114a5c11a82735536.jpg",
                      @"http://i.cqnews.net/cbg/attachement/jpg/site1/20170514/00ea0114a5c11a82682524.jpg",
                      @"http://i.cqnews.net/cbg/attachement/png/site1/20170513/1c6f652157381a8126b00b.png", nil];
    
    }
    
    return _imageurls;

}

- (NSMutableArray *)urls {

    if(!_urls) {
    
        _urls = [NSMutableArray arrayWithObjects:@"http://live.cqnews.net/data/video/201705/10/2c24c05b-455b-4348-f6b9-1ab748168e87/transcode_9c44fac4-6bf7-8c9f-9b15-7e9fddc2.mp4",
                 @"http://live.cqnews.net/data/video/201705/10/60d57a77-66fa-45ed-aff2-fdcdc682aa74/transcode_c9792a6b-f90b-119f-d181-d4d68ebe.mp4",
                 @"http://live.cqnews.net/data/video/201705/10/dff994f2-e178-4398-acb1-df29b7ae4189/transcode_60f0870e-2780-e458-24cc-c78cb9ad.mp4",
                 @"http://live.cqnews.net/data/video/201705/10/424786b1-9ee0-4033-b5ea-6ecbf38076bf/transcode_5896fc94-3ef0-69b7-8ec9-081b107a.mp4",
                 @"http://live.cqnews.net/data/video/201705/14/35b68055-916b-477b-f5dd-0ecd9c2cd3d1/transcode_f791b3e3-d136-6ee6-0f28-29f14728.mp4",
                 @"http://live.cqnews.net/data/video/201705/14/c3e14d5b-916b-4048-d37d-a7d00aca269f/transcode_9e480910-be47-55ae-16e4-fba5567e.mp4",
                 @"http://live.cqnews.net/data/video/201705/14/c3f8e2c8-71dc-48ec-f27f-a1a139c2f949/transcode_70c96a7a-6879-bda4-1142-a9c9922b.mp4",
                 @"http://live.cqnews.net/data/video/201705/13/f7c7dd0a-c032-46e3-e225-4a71151d3033/transcode_f96baa9e-3f03-f4f4-52d5-40a0d316.mp4", nil];
    
    }
    
    return _urls;

}

- (AVPlayerLayer *)playerLayer {

    if(!_playerLayer) {
    
        _playerLayer = [[AVPlayerLayer alloc] init];
        _playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        _playerLayer.frame = CGRectMake(10, 100, CGRectGetWidth(self.view.frame) - 20, CGRectGetWidth(self.view.frame) * 9.0 / 16.0);
        [self.bgScroll.layer addSublayer:_playerLayer];
        
    }
    
    return _playerLayer;

}

- (AVPlayer *)player {

    if(!_player) {
    
        _player = [[AVPlayer alloc] init];
    
    }
    
    return _player;

}

//- (void)loadViews {
//    
//    [super loadViews];
//    
//    self.urls_index = 0;
//    UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
//    [add addTarget:self action:@selector(addIndex:) forControlEvents:UIControlEventTouchUpInside];
//    [add setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [add setTitle:@"++++++" forState:UIControlStateNormal];
//    add.frame = CGRectMake(40, self.playerLayer.frame.origin.y + self.playerLayer.frame.size.height + 40, CGRectGetWidth(self.view.frame) - 80, 40);
//    [self.bgScroll addSubview:add];
//    
//    self.playerLayer.player = self.player;
//    
//}
//
//- (void)compent:(NSInteger)index {
//    
//    if(_asset) {
//    
//        _asset = nil;
//    
//    }
//    
//    if(self.playerItem) {
//    
//        self.playerItem = nil;
//    
//    }
//    
//    _asset = [AVAsset assetWithURL:[NSURL URLWithString:self.urls[index]]];
//    NSArray *keys = @[@"tracks",
//                      @"playable",
//                      @"duration"];
//    
//    NSLog(@"==========  no.1");
//    self.playerItem = [[AVPlayerItem alloc] initWithAsset:_asset];
//    NSLog(@"==========  no.2");
//
//    NSLog(@"==========  no.3");
//    
//    __weak AVPlayer *weakPlayer = self.player;
//    __weak AVAsset *weakAsset1 = _asset;
//    [_asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
//        
//        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
//                
//                NSError *error = nil;
//                AVKeyValueStatus keyStatus = [weakAsset1 statusOfValueForKey:key error:&error];
//                
//                switch (keyStatus) {
//                    case AVKeyValueStatusFailed:
//                    {
//                        
////                        NSLog(@"---------------- fail");
//                        
//                    }
//                        break;
//                    case AVKeyValueStatusLoaded:
//                    {
//                        
////                        NSLog(@"---------------- success");
//                        if([key isEqualToString:@"playable"]) {
//                            
//                            [weakPlayer play];
//                            
//                        }
//                        
//                    }
//                        break;
//                    case AVKeyValueStatusCancelled:
//                    {
//                        
////                        NSLog(@"---------------- cancel");
//                        
//                    }
//                        break;
//                    default:
//                        break;
//                }
//                
//                
//            }];
//            
//            if(!weakAsset1.playable) {
//                
//                NSLog(@"---------------- 这个 asset 不能播放");
//                return;
//                
//            }
//            
//        });
//        
//    }];
//
//}
//
//- (void)addIndex:(UIButton *)sender {
//
//    [self compent:self.urls_index];
//    self.urls_index++;
//    if(self.urls_index >= 8) {
//    
//        self.urls_index = 0;
//    
//    }
//
//}

- (void)loadViews {

    [super loadViews];
    self.table = [[UITableView alloc] initWithFrame:CGRectZero];
    self.table.delegate = self;
    self.table.dataSource = self;
    UIView *clearView = [UIView new];
    clearView.backgroundColor = [UIColor clearColor];
    [self.table setTableFooterView:clearView];
    [self.view addSubview:self.table];

}

- (void)loadLayout {

    [super loadLayout];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.imageurls.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return CGRectGetWidth(self.view.frame) * 9.0 / 16.0 + 40;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"ZURLAssetCell";
    ZURLAssetCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
    
        cell = [[ZURLAssetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    }
    [cell setImage:self.imageurls[indexPath.row] url:self.urls[indexPath.row]];
    
    return cell;

}

@end
