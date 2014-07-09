//
//  ChiquitoViewController.m
//  Chiquito
//
//  Created by Miguel Martin Nieto on 09/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "ChiquitoViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ImagePool.h"
#import "SoundEffect.h"
#import "DeviceHardwareHelper.h"


@interface ChiquitoViewController ()

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) AVCaptureDevice *device;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) ImagePool *imagePool;
@property (strong, nonatomic) SoundEffect *effect;
@property (strong, nonatomic) DeviceHardwareHelper *deviceHelper;


@end

@implementation ChiquitoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imagePool = [[ImagePool alloc] initWithFileName:@"chiquitoImages"];
    self.effect = [[SoundEffect alloc] init];
    self.effect.delegate = self;
    self.deviceHelper = [[DeviceHardwareHelper alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    [self.deviceHelper onProximityEventApproachDoThis:^{
        [weakSelf.effect play:@"Cuidadin"];
    }];
    [self.deviceHelper onProximityEventLeavingDoThis:^{
        [weakSelf.effect play:@"Ioputarl"];
    }];
    
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

- (void) initTimer{
    [self.timer fire];
}

- (void)reproduceSound{
    
    [self.effect play:@"Lucas"];
    [DeviceHardwareHelper vibrate];
    [DeviceHardwareHelper torchOn];
    
}

- (void)soundEffectDidFinishPlaying:(SoundEffect *)soundEffect{
    [DeviceHardwareHelper torchOff];
}


- (void)stopSound {
    [self.timer invalidate];
    self.timer = nil;
    [DeviceHardwareHelper torchOff];
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion == UIEventSubtypeMotionShake) {
        UIImage *img = [self.imagePool nextImage];
        self.imageView.image = img;
        [self.effect play:@"Iiihii"];
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
    [self.effect play:@"Cuidadin"];
}



@end
