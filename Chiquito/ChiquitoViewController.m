//
//  ChiquitoViewController.m
//  Chiquito
//
//  Created by Miguel Martin Nieto on 09/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "ChiquitoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ChiquitoViewController ()

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) AVAudioPlayer *player;

@end

@implementation ChiquitoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.timer fire];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopSound)];
    recognizer.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:recognizer];
}

- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(reproduceSound) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)reproduceSound{
    NSLog(@"Pecador!!!!");
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Pecador"ofType:@"wav"];
    NSError *err = nil;
    NSData *soundData = [[NSData alloc] initWithContentsOfFile:filePath options:NSDataReadingMapped error:&err];
    
    AVAudioPlayer *p = [[AVAudioPlayer alloc] initWithData:soundData error:&err];
    self.player = p;
    [self.player play];

    
}

- (void)stopSound {
    [self.timer invalidate];
    self.timer = nil;
}

@end
