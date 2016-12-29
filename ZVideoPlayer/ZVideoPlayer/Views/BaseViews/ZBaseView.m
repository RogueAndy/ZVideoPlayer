//
//  ZBaseView.m
//  ZLJUI
//
//  Created by dazhongge on 2016/12/20.
//  Copyright © 2016年 dazhongge. All rights reserved.
//

#import "ZBaseView.h"

@implementation ZBaseView

- (instancetype)initWithFrame:(CGRect)frame {

    if(self = [super initWithFrame:frame]) {
    
        [self loadInit];
        [self loadViews];
        [self loadLayout];
    
    }
    
    return self;

}

- (void)loadInit {
    
    NSLog(@"-------------------- start loadInit Method\n\n");
    
}

- (void)loadViews {
    
    NSLog(@"-------------------- start loadViews Method\n\n");
    
}

- (void)loadLayout {
    
    NSLog(@"-------------------- start loadLayout Method\n\n");
    
}

@end
