//
//  ZAssetViewController.m
//  ZVideoPlayer
//
//  Created by rogue on 2017/5/26.
//  Copyright © 2017年 dazhongge. All rights reserved.
//

#import "ZAssetViewController.h"

@interface ZAssetViewController ()

@end

@implementation ZAssetViewController


- (void)loadInit {

    [super loadInit];
    
    NSString *str1 = @"111";
    NSString *str2 = @"222";
    [self str1:str1 str2:str2];
//    [self str11:&str1 str22:&str2];
    NSLog(@"out.  %@   ---   %@", str1, str2);

}

- (void)str1:(NSString *)str1 str2:(NSString *)str2 {

    NSString *str3 = @"";
    str3 = str1;
    
    NSLog(@"1.  %@   ---   %@   ---   %@", str1, str2, str3);
    
    str1 = str2;
    
    NSLog(@"2.  %@   ---   %@   ---   %@", str1, str2, str3);
    
    str2 = str3;
    
    str2 = @"测试而已";
    
    NSLog(@"3.  %@   ---   %@   ---   %@", str1, str2, str3);

}

- (void)str11:(NSString **)str1 str22:(NSString **)str2 {

    NSString *str3 = *str1;
    
    NSLog(@"1.  %@   ---   %@   ---   %@", *str1, *str2, str3);
    
    *str1 = *str2;

    NSLog(@"1.  %@   ---   %@   ---   %@", *str1, *str2, str3);

    *str2 = str3;
    
    *str2 = @"测试而已";

    NSLog(@"1.  %@   ---   %@   ---   %@", *str1, *str2, str3);
    

}

@end
