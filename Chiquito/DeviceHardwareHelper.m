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


@implementation DeviceHardwareHelper

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
