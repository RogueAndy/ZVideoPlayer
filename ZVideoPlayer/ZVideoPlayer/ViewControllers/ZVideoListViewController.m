//
//  ZVideoListViewController.m
//  ZVideoPlayer
//
//  Created by rogue on 2017/5/11.
//  Copyright © 2017年 dazhongge. All rights reserved.
//

#import "ZVideoListViewController.h"
#import "ZVideoListCell.h"

@interface ZVideoListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) NSArray *urls;

@property (nonatomic, strong) UIView *testView;

/**
 记录播放视频的一行cell
 */
@property (nonatomic) NSInteger whichCellIsPlayVideo;

@end

@implementation ZVideoListViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.whichCellIsPlayVideo = -1;
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64)];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    
    self.images = @[@"http://i.cqnews.net/cbg/attachement/png/site1/20170510/000b0e0f00ed1a7d6a4111.png",
                    @"http://i.cqnews.net/cbg/attachement/png/site1/20170510/000b0e0f00ed1a7d68990e.png",
                    @"http://i.cqnews.net/cbg/attachement/jpg/site1/20170510/000b0e0f00ed1a7d5b0c63.jpg",
                    @"http://i.cqnews.net/cbg/attachement/jpg/site1/20170510/000b0e0f00ed1a7d57ca60.jpg",
                    @"http://i.cqnews.net/cbg/attachement/png/site1/20170514/00ea0114a5c11a827b0648.png",
                    @"http://i.cqnews.net/cbg/attachement/jpg/site1/20170514/00ea0114a5c11a82735536.jpg",
                    @"http://i.cqnews.net/cbg/attachement/jpg/site1/20170514/00ea0114a5c11a82682524.jpg",
                    @"http://i.cqnews.net/cbg/attachement/png/site1/20170513/1c6f652157381a8126b00b.png"
                    ];
    self.urls = @[@"http://live.cqnews.net/data/video/201705/10/2c24c05b-455b-4348-f6b9-1ab748168e87/transcode_9c44fac4-6bf7-8c9f-9b15-7e9fddc2.mp4",
                    @"http://live.cqnews.net/data/video/201705/10/60d57a77-66fa-45ed-aff2-fdcdc682aa74/transcode_c9792a6b-f90b-119f-d181-d4d68ebe.mp4",
                    @"http://live.cqnews.net/data/video/201705/10/dff994f2-e178-4398-acb1-df29b7ae4189/transcode_60f0870e-2780-e458-24cc-c78cb9ad.mp4",
                    @"http://live.cqnews.net/data/video/201705/10/424786b1-9ee0-4033-b5ea-6ecbf38076bf/transcode_5896fc94-3ef0-69b7-8ec9-081b107a.mp4",
                  @"http://live.cqnews.net/data/video/201705/14/35b68055-916b-477b-f5dd-0ecd9c2cd3d1/transcode_f791b3e3-d136-6ee6-0f28-29f14728.mp4",
                  @"http://live.cqnews.net/data/video/201705/14/c3e14d5b-916b-4048-d37d-a7d00aca269f/transcode_9e480910-be47-55ae-16e4-fba5567e.mp4",
                  @"http://live.cqnews.net/data/video/201705/14/c3f8e2c8-71dc-48ec-f27f-a1a139c2f949/transcode_70c96a7a-6879-bda4-1142-a9c9922b.mp4",
                  @"http://live.cqnews.net/data/video/201705/13/f7c7dd0a-c032-46e3-e225-4a71151d3033/transcode_f96baa9e-3f03-f4f4-52d5-40a0d316.mp4"
                    ];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.images.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 200.0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"ZVideoListCell";
    ZVideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
    
        cell = [[ZVideoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    }
    
    __weak ZVideoListViewController *weakSelf = self;
    [cell setImage:self.images[indexPath.row] urlString:self.urls[indexPath.row] cellIndex:indexPath.row clickCell:^(NSInteger index) {
    
        if(weakSelf.whichCellIsPlayVideo >= 0) {
        
            ZVideoListCell *currentCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.whichCellIsPlayVideo inSection:0]];
            [currentCell closePlayer];
        
        }
        weakSelf.whichCellIsPlayVideo = index;

    }];

    cell.returnCellRectInSuperView = ^CGRect{
        return [weakSelf countCellRectConvertIntoViewControllerRect:weakSelf.table cellForIndex:indexPath];
    };
    cell.superViewController = self.navigationController;
    [cell scrollClosePlayer];
    
    return cell;

}

#pragma mark - 转换 cell 的位置到当前控制器 view 的坐标系
- (CGRect)countCellRectConvertIntoViewControllerRect:(UITableView *)tableView cellForIndex:(NSIndexPath *)indexPath  {

    CGRect cellFrame = [tableView rectForRowAtIndexPath:indexPath];
    return [tableView convertRect:cellFrame toView:self.view];

}

@end
