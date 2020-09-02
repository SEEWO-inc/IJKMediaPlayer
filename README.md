# IJKMediaPlayer

## Summary
基于 [ijkplayer](https://github.com/bilibili/ijkplayer) 编译的Static and Dynamic Framework，支持常见主流视频格式播放，支持https, 支持rtmp。

感谢优秀的的ijkplayer项目的作者及其贡献者为开源社区做出的贡献，这里只是通过更改配置文件来进行编译得到Framework，未对源码部分做修改。

编译依赖
1. ffmpeg版本：ff3.4--ijk0.8.7--20180612--001
2. openssl版本：OpenSSL_1_0_2u
3. 如果需要编译依赖ffmpeg4.0的版本，参考 compile.md

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
1. iOS 9+
2. Only support arm64 and x86_64 archs
3. not bitcode support（recompile if needed）


## Installation

IJKMediaPlayer is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby

pod "IJKMediaPlayer", :podspec => 'https://raw.githubusercontent.com/SEEWO-inc/IJKMediaPlayer/master/IJKMediaPlayer.podspec'


pod update 
or
pod install

```
暂时没有推送到cocoapods官方仓库，你也可以下载下来直接私有部署到公司内部仓库。

## Media Support

Container: mp4, mov, mkv, 3gp, mpg, flv, wmv, rm, rmvb, avi, m4v, asf, m4a, webm, caf, ogg, ts

Video decoder: wmv1~3, h263, h264, hevc, mpeg*, msmpeg*, rv*, vp*, theora

Audio decoder: mp1~3, ac3, aac, amr*, alac, flac, opus, vorbis, cook

Not support: swf

使用中如果遇到无法播放的视频，请查看视频和音频的编码格式，然后重新编译 [ijkplayer && ffmpeg]

编译参考：compile.md

## Usage

```ruby

#import <IJKMediaFrameworkWithSSL/IJKMediaFrameworkWithSSL.h> // Dynamic Framework


id<IJKMediaPlayback> player;

[IJKFFMoviePlayerController setLogReport:YES];
[IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_VERBOSE];
    
IJKFFOptions *options = [IJKFFOptions optionsByDefault];
[options setPlayerOptionIntValue:1 forKey:@"enable-accurate-seek"];
[options setPlayerOptionIntValue:1 forKey:@"videotoolbox"];
    
NSString *testUrl = @"http://edu.seewo.com/api/v1/drive/NDAxN2ZkYTg3OWFmNDBlZmI5YzQzYzczYmU0MTdkMDA=/permanent/url/YzFjMzI4NzM2YTY1NDdkODg0OGI5ZjA1MTcxMjEwZjQ=?redirectResType=0";
    
NSURL *test = [NSURL URLWithString:testUrl];
player = [[IJKFFMoviePlayerController alloc] initWithContentURL:test withOptions:options];
    
player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
player.view.frame = self.view.bounds;
player.scalingMode = IJKMPMovieScalingModeAspectFit;
player.shouldAutoplay = YES;    
[player prepareToPlay];

```

## Author

郭庆伟, guoqingwei@cvte.com

## License

IJKMediaPlayer is available under the MIT license. See the LICENSE file for more info.
