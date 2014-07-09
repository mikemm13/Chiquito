//
//  DeviceHardwareHelper.m
//  Chiquito
//
//  Created by Miguel Martin Nieto on 09/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "DeviceHardwareHelper.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^SIMPLE_BLOCK)();


@interface DeviceHardwareHelper ()
@property (strong, nonatomic) SIMPLE_BLOCK enterBlock;
@property (strong, nonatomic) SIMPLE_BLOCK leaveBlock;
@end

@implementation DeviceHardwareHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateChanged) name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
    return self;
}

- (void)onProximityEventApproachDoThis:(SIMPLE_BLOCK)action{
    self.enterBlock = action;
}

- (void)onProximityEventLeavingDoThis:(SIMPLE_BLOCK)action{
    self.leaveBlock = action;
}

- (void)proximityStateChanged{
    if ([[UIDevice currentDevice] proximityState] == YES) {
        //launch on approaching block
        self.enterBlock();
    } else {
        self.leaveBlock();
    }
}

+ (void)vibrate{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

+ (void)torchOn{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    [device setTorchMode: AVCaptureTorchModeOn];
    [device unlockForConfiguration];

}

+ (void)torchOff{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    [device setTorchMode: AVCaptureTorchModeOff];
    [device unlockForConfiguration];
    
}



@end
