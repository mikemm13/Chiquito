//
//  ImagePool.m
//  Chiquito
//
//  Created by Miguel Martin Nieto on 09/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "ImagePool.h"

@interface ImagePool()
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSString *fileName;
@end

@implementation ImagePool

- (instancetype)init
{
    self = [super init];
    if (self) {
        _images = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithFileName:(NSString *)fileName{
    self = [super init];
    if (self) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
        _images = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    }
    return self;
}


- (NSArray *)imageNames{
    return self.images.copy;
}


-(UIImage *)nextImage{
    NSInteger index;
    index = [self nextIndex];
    return [UIImage imageNamed:self.images[index]];
}

- (NSInteger)nextIndex {
    NSInteger index = arc4random()%self.images.count;
    return index;
}

- (NSString *)nextImageName{
    NSInteger index = [self nextIndex];
    return self.images[index];
}


- (void)addImageNamed:(NSString *)imageName{
    [self.images addObject:imageName];
}



@end
