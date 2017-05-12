//
//  RgScreenShot.m
//  RgFeinno
//
//  Created by Rogue Andy on 16/8/30.
//  Copyright © 2016年 RogueAndy. All rights reserved.
//

#import "RgScreenShot.h"

@implementation RgScreenShot

#pragma mark - 外部可调用的静态方法

+ (UIImage *)imageWithViewController:(UIViewController *)viewController {

    return [[RgScreenShot new] imageWithViewController:viewController];

}

+ (UIImage *)imageWithView:(UIView *)view {

    return [[RgScreenShot new] imageWithView:view];

}

+ (UIImage *)imageWithScrollView:(UIScrollView *)scrollView {

    return [[RgScreenShot new] imageWithScrollView:scrollView];

}

#pragma mark - 私有方法

- (UIImage *)imageWithViewController:(UIViewController *)viewController {

    return [self imageWithView:viewController.view];

}

- (UIImage *)imageWithView:(UIView *)view {

    return [self imageWithView:view shotSize:CGSizeZero];
    
}

- (UIImage *)imageWithScrollView:(UIScrollView *)scrollView {

    return [self imageWithScrollView:scrollView shotSize:CGSizeZero];

}

#pragma mark - 底层方法

- (CGSize)isCGSizeZero:(CGSize)size inView:(UIView *)view {

    if(CGSizeEqualToSize(size, CGSizeZero)) {
    
        size = view.frame.size;
    
    }
    
    return size;

}

- (CGSize)isCGSizeZero:(CGSize)size inScrollView:(UIScrollView *)view {
    
    if(CGSizeEqualToSize(size, CGSizeZero)) {
        
        size = [view contentSize];
        
    }
    
    return size;
    
}

- (UIImage *)imageWithView:(UIView *)view shotSize:(CGSize)size {
    
    size = [self isCGSizeZero:size inView:view];
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, 1);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = image.CGImage;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGImageRef imageRefRect = CGImageCreateWithImageInRect(imageRef, rect);
    
    UIImage *returnImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    
    
    return returnImage;

}

- (UIImage *)imageWithScrollView:(UIScrollView *)scroll shotSize:(CGSize)size {

    size = [self isCGSizeZero:size inScrollView:scroll];
    
    UIImage *image = nil;
    
    UIGraphicsBeginImageContext(scroll.contentSize);
    CGPoint savedContentOffset = [scroll contentOffset];
    CGRect saveFrame = scroll.frame;
    scroll.contentOffset = CGPointZero;
    scroll.frame = CGRectMake(0, 0, size.width, size.height);
    [scroll.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    scroll.contentOffset = savedContentOffset;
    scroll.frame = saveFrame;
    
    UIGraphicsGetCurrentContext();
    
    return image;
    
}

@end
