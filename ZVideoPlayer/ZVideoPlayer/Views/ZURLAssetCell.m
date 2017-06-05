//
//  ZURLAssetCell.m
//  ZVideoPlayer
//
//  Created by rogue on 2017/5/27.
//  Copyright © 2017年 dazhongge. All rights reserved.
//

#import "ZURLAssetCell.h"
#import "ZButton.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface ZURLAssetCell()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) ZButton *playerButton;

@property (nonatomic, strong) NSString *url;

@end

@implementation ZURLAssetCell

- (void)loadViews {

    [super loadViews];
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.bgImageView.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.bgImageView];
    
    self.playerButton = [ZButton buttonWithType:UIButtonTypeCustom];
    [self.playerButton addTarget:self action:@selector(zbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playerButton setImage:[[UIImage imageNamed:@"videobegin"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.bgImageView addSubview:self.playerButton];

}

- (void)loadLayout {

    [super loadLayout];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(self.contentView.mas_height).offset(-40);
        
    }];

    [self.playerButton mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.width.height.mas_equalTo(80);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.centerX.equalTo(self.contentView.mas_centerX);
        
    }];
    
}

- (void)zbuttonAction:(ZButton *)sender {

    if(sender.isPlaying) {
    
        
        return;
        
    }

}

- (void)setImage:(NSString *)image url:(NSString *)url {

    self.url = url;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"gdf"]];

}

@end
