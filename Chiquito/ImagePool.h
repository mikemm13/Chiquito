//
//  ImagePool.h
//  Chiquito
//
//  Created by Miguel Martin Nieto on 09/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImagePool : NSObject
- (id)init;
- (id)initWithFileName:(NSString *)fileName;

- (NSArray *)imageNames;

- (UIImage *) nextImage;
- (NSString *) nextImageName;

- (void)addImageNamed:(NSString *)imageName;


@end
