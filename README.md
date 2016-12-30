#视频类的实现，已经实现了基本的 View 类，只需要配合 ViewController使用即可
主要是视图类 ZVideoPlayerView,因为是基于 AVPlayer所以支持ios8+
![image](https://github.com/RogueAndy/ZVideoPlayer/blob/master/ZVideoPlayer/ZVideoPlayer/example_11.gif) 

##方法的使用
主要是针对ZVideoPlayerView这个类来说明。

有2个初始化方法:
### + (instancetype)initWithOnlineVideo:(NSString *)fileUrl;
这个是在线视频的初始化方法，比如说播放网络在线的视频，必须输入网络播放路径。

### + (instancetype)initWithLocalVideo:(NSString *)filePath;
这个是本地视频的初始化方法，你必须录入本地视频的路径，e'g 
```
NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"ceshivideo" ofType:@"mov"];
    self.videoPlayerView = [ZVideoPlayerView initWithLocalVideo:videoPath];
```

有2个外部属性:
### isPlay
该属性主要用于外部控制视频的播放或暂停.
### removeViewBlock 
当用户在关闭该View的时候，希望自己添加一些效果以及动画，可以在这个回调函数实现，如果你希望在关闭视图层后，能够清除掉内存，尽量按照示例:
```
__weak ZVideoPlayerController *weakSelf = self;
    self.videoPlayerView.removeViewBlock = ^{
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             weakSelf.videoPlayerView.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [weakSelf.videoPlayerView removeFromSuperview];
                             weakSelf.videoPlayerView = nil;
                         }];
        
    };
```

还有一个动态方法:
### - (void)showViewIn:(UIView *)superView animation:(BOOL)animation;
当你初始化该对象之后，不必再 
```
[self.view addSubview:self.videoPlayerView]
```
你只需要
```
[self.videoPlayerView showViewIn:self.navigationController.view animation:YES];
```


