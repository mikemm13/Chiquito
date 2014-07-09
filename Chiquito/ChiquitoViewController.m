//
//  ChiquitoViewController.m
//  Chiquito
//
//  Created by Miguel Martin Nieto on 09/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "ChiquitoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ChiquitoViewController ()

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) AVCaptureDevice *device;
@property (strong, nonatomic) NSArray *images;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ChiquitoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.timer fire];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Pecador"ofType:@"wav"];
    NSError *err = nil;
    NSData *soundData = [[NSData alloc] initWithContentsOfFile:filePath options:NSDataReadingMapped error:&err];
    AVAudioPlayer *p = [[AVAudioPlayer alloc] initWithData:soundData error:&err];
    self.player = p;
    self.player.delegate = self;
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

- (NSArray *)images{
    if (!_images) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"chiquitoImages" ofType:@"plist"];
        _images = [NSArray arrayWithContentsOfFile:filePath];
    }
    return _images;
}

- (void)reproduceSound{
    NSLog(@"Pecador!!!!");
    
    
    
    [self.player play];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [self.device lockForConfiguration:nil];
    [self.device setTorchMode: AVCaptureTorchModeOn];
    [self.device unlockForConfiguration];
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self.device lockForConfiguration:nil];
    [self.device setTorchMode: AVCaptureTorchModeOff];
    [self.device unlockForConfiguration];
}


- (void)stopSound {
    [self.timer invalidate];
    self.timer = nil;
    [self.device lockForConfiguration:nil];
    [self.device setTorchMode: AVCaptureTorchModeOff];
    [self.device unlockForConfiguration];
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"shake");
        NSInteger index = arc4random()%4;
        self.imageView.image = [UIImage imageNamed:self.images[index]];
    }
}

@end
