//
//  ZVVideoNavigationController.m
//  ZVideoPlayer
//
//  Created by rogue on 2017/5/15.
//  Copyright © 2017年 dazhongge. All rights reserved.
//

#import "ZVVideoNavigationController.h"

@interface ZVVideoNavigationController ()

@end

@implementation ZVVideoNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//支持旋转

-(BOOL)shouldAutorotate{
    
    return [self.topViewController shouldAutorotate];
    
}

//支持的方向

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return [self.topViewController supportedInterfaceOrientations];
    
}

@end
