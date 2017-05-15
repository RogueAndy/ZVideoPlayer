//
//  ZBaseViewController.m
//  ZLJUI
//
//  Created by dazhongge on 2016/12/20.
//  Copyright © 2016年 dazhongge. All rights reserved.
//

#import "ZBaseViewController.h"

@interface ZBaseViewController ()

@end

@implementation ZBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadInit];
    [self loadViews];
    [self loadLayout];
    
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

- (void)dealloc {

    NSLog(@"-------------------- %@ is dealloc \n\n", [self class]);

}

@end
