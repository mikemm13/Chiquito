//
//  DeviceHardwareHelper.h
//  Chiquito
//
//  Created by Miguel Martin Nieto on 09/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceHardwareHelper : NSObject

- (void)onProximityEventApproachDoThis:(void(^)())action;
- (void)onProximityEventLeavingDoThis:(void(^)())action;

+ (void)vibrate;
+ (void)torchOn;
+ (void)torchOff;


@end
