//
//  ZSinglePlayerX.m
//  ZVideoPlayer
//
//  Created by rogue on 2017/5/11.
//  Copyright © 2017年 dazhongge. All rights reserved.
//

#import "ZSinglePlayerX.h"

static ZSinglePlayerX *single = nil;

@interface ZSinglePlayerX()

@end

@implementation ZSinglePlayerX

+ (instancetype)shareInstance {

    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        single = [[self alloc] init];
        
    });
    
    return single;

}

+ (instancetype)initWithOnlineVideo:(NSString *)fileUrl {

    [[self shareInstance] setUrlString:fileUrl];
    return single;

}

+ (void)closePlayer {

    [[self shareInstance] closePlayer];

}

@end
