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
#import <CoreMotion/CoreMotion.h>
#import <MobileCoreServices/MobileCoreServices.h>

double currentMaxAccelX;
double currentMaxAccelY;
double currentMaxAccelZ;
double currentMaxRotX;
double currentMaxRotY;
double currentMaxRotZ;

@interface ChiquitoViewController ()

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) AVCaptureDevice *device;
@property (strong, nonatomic) NSArray *images;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) CMMotionManager *motionManager;


@end

@implementation ChiquitoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currentMaxAccelX = 0;
    currentMaxAccelY = 0;
    currentMaxAccelZ = 0;
    
    currentMaxRotX = 0;
    currentMaxRotY = 0;
    currentMaxRotZ = 0;
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .2;
    self.motionManager.gyroUpdateInterval = .2;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 [self outputAccelertionData:accelerometerData.acceleration];
                                                 if(error){
                                                     
                                                     NSLog(@"%@", error);
                                                 }
                                             }];
    
    [self.timer fire];
    
    
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateChanged) name:UIDeviceProximityStateDidChangeNotification object:nil];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopSound)];
    recognizer.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:recognizer];
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(useCamera:)];
    [self.view addGestureRecognizer:swipeRecognizer];
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(useCameraRoll:)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftRecognizer];
    UISwipeGestureRecognizer *downRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(initTimer)];
    downRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:downRecognizer];

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

- (void) initTimer{
    [self.timer fire];
}

- (void)reproduceSound{
    NSLog(@"Pecador!!!!");
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Lucas"ofType:@"wav"];
    NSError *err = nil;
    NSData *soundData = [[NSData alloc] initWithContentsOfFile:filePath options:NSDataReadingMapped error:&err];
    AVAudioPlayer *p = [[AVAudioPlayer alloc] initWithData:soundData error:&err];
    self.player = p;
    self.player.delegate = self;
    
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
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Iiihii"ofType:@"wav"];
        NSError *err = nil;
        NSData *soundData = [[NSData alloc] initWithContentsOfFile:filePath options:NSDataReadingMapped error:&err];
        self.player = [[AVAudioPlayer alloc] initWithData:soundData error:&err];
        [self.player play];
        self.player.delegate = self;
    }
}


-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    
    if(acceleration.z > 0.95 && acceleration.z < 1.05)
    {
        [self stopSound];
    }
    
}

- (void) useCamera:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
    }
}



- (void) useCameraRoll:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        
    }
}



-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        _imageView.image = image;
            }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
}

- (void)proximityStateChanged{
    NSLog(@"Sensor");
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Cuidadin"ofType:@"wav"];
    NSError *err = nil;
    NSData *soundData = [[NSData alloc] initWithContentsOfFile:filePath options:NSDataReadingMapped error:&err];
    AVAudioPlayer *p = [[AVAudioPlayer alloc] initWithData:soundData error:&err];
    self.player = p;
    self.player.delegate = self;
    [self.player play];
}



@end
