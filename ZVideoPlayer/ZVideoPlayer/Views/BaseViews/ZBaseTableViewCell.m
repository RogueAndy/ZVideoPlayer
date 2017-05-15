//
//  ZBaseTableViewCell.m
//  ZLJUI
//
//  Created by dazhongge on 2016/12/22.
//  Copyright © 2016年 dazhongge. All rights reserved.
//

#import "ZBaseTableViewCell.h"

@implementation ZBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        [self loadInit];
        [self loadViews];
        [self loadLayout];
    
    }
    
    return self;

}

- (void)loadInit {
    
//    NSLog(@"-------------------- start loadInit Method\n\n");
    
}

- (void)loadViews {
    
//    NSLog(@"-------------------- start loadViews Method\n\n");
    
}

- (void)loadLayout {
    
//    NSLog(@"-------------------- start loadLayout Method\n\n");
    
}

@end
