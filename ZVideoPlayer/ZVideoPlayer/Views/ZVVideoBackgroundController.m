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
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forbidCrash:)];
    [self.view addGestureRecognizer:tap];

}

- (UIImageView *)imageViewC {

    if(!_imageViewC) {
    
        _imageViewC = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_imageViewC];
    
    }
    
    return _imageViewC;

}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

}

/**
 设置背景图片

 @param image <#image description#>
 */
- (void)setImage:(UIImage *)image {

    _image = image;
    self.imageViewC.image = _image;
    
    CGAffineTransform left = CGAffineTransformMakeRotation(270 *M_PI / 180.0);
    [self.imageViewC setTransform:left];
    self.imageViewC.frame = CGRectMake(0, 0, CGRectGetHeight([[UIScreen mainScreen] bounds]), CGRectGetWidth([[UIScreen mainScreen] bounds]));
    
}

- (void)forbidCrash:(UITapGestureRecognizer *)tap {

    [self dismissViewControllerAnimated:NO completion:nil];

}

- (BOOL)prefersStatusBarHidden {

    return YES;

}

- (void)dealloc {

    self.image = nil;
    NSLog(@"------------------ %@", [self class]);

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
