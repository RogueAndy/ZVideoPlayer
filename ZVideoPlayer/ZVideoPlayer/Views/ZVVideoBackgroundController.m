//
//  ZVVideoBackgroundController.m
//  ZVideoPlayer
//
//  Created by rogue on 2017/5/12.
//  Copyright © 2017年 dazhongge. All rights reserved.
//

#import "ZVVideoBackgroundController.h"

@interface ZVVideoBackgroundController ()

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIImageView *imageViewC;

@end

@implementation ZVVideoBackgroundController

+ (instancetype)initWithBackgroundImage:(UIImage *)image {

    ZVVideoBackgroundController *vc = [ZVVideoBackgroundController new];
    vc.image = image;
    return vc;

}

- (void)viewDidLoad {

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBarHidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forbidCrash:)];
    [self.view addGestureRecognizer:tap];
    
    self.imageViewC = [[UIImageView alloc] init];
//    CGAffineTransform left = CGAffineTransformMakeRotation(M_PI * 1.5);
//    [self.imageViewC setTransform:left];
//    NSLog(@"%@", [NSValue valueWithCGRect:[[UIScreen mainScreen] bounds]]);
//    self.imageViewC.frame = CGRectMake(0, 0, CGRectGetHeight([[UIScreen mainScreen] bounds]), CGRectGetWidth([[UIScreen mainScreen] bounds]));
    self.imageViewC.frame = [[UIScreen mainScreen] bounds];
    self.imageViewC.image = self.image;
    [self.view addSubview:self.imageViewC];

}


- (void)forbidCrash:(UITapGestureRecognizer *)tap {

    [self dismissViewControllerAnimated:NO completion:nil];

}

- (BOOL)prefersStatusBarHidden {

    return NO;

}

- (void)dealloc {

    [self.imageViewC removeFromSuperview];
    self.imageViewC = nil;
    self.image = nil;
    NSLog(@"------------------ %@ has dealloc!!!", [self class]);

}

/**
 设置不支持横屏旋转

 @return 布尔类型
 */
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAll;
}

/**
 进入控制器之后，自动默认屏幕方向

 @return 方向
 */
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return  UIInterfaceOrientationLandscapeRight;
    
}

@end
