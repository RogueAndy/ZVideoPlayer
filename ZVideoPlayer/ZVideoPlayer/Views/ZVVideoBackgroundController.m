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

- (void)setImage:(UIImage *)image {

    _image = image;
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];

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



@end
