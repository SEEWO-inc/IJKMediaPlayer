//
//  IJKViewController.m
//  IJKMediaPlayer
//
//  Created by qqingweihao@163.com on 08/25/2020.
//  Copyright (c) 2020 qqingweihao@163.com. All rights reserved.
//

#import "IJKViewController.h"

#import <IJKMediaFrameworkWithSSL/IJKMediaFrameworkWithSSL.h>


@interface IJKViewController ()

@property (nonatomic, strong) id<IJKMediaPlayback> player;

@end

@implementation IJKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)setupPlayer {
   
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_VERBOSE];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    [options setPlayerOptionIntValue:1 forKey:@"enable-accurate-seek"];
    [options setPlayerOptionIntValue:1 forKey:@"videotoolbox"];
    
    NSString *testUrl = @"http://edu.seewo.com/api/v1/drive/NDAxN2ZkYTg3OWFmNDBlZmI5YzQzYzczYmU0MTdkMDA=/permanent/url/YzFjMzI4NzM2YTY1NDdkODg0OGI5ZjA1MTcxMjEwZjQ=?redirectResType=0";
    
//    NSString *testUrl = @"rtmp://ws-live-rtmp.test.seewoedu.cn/live/09a522ef9cc14f19b2d4f214c27a1c0c";
    
    
    NSURL *test = [NSURL URLWithString:testUrl];
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:test withOptions:options];
    

    
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = self.view.bounds;
    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
    self.player.shouldAutoplay = YES;
    
    
    [self.view insertSubview:self.player.view atIndex:0];
    
    [self.player prepareToPlay];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
