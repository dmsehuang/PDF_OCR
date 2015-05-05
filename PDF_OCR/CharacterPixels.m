//
//  CharacterPixels.m
//  PDF_OCR
//
//  Created by huijinghuang on 4/26/15.
//  Copyright (c) 2015 huijinghuang. All rights reserved.
//

#import "CharacterPixels.h"
#import "Character.h"

@implementation CharacterPixels

- (id)init {
    self = [super init];
    if (self) {
        self.x_arr = [[NSMutableArray alloc] init];
        self.y_arr = [[NSMutableArray alloc] init];
        self.x_min = INT_MAX;
        self.x_max = 0;
        self.y_min = INT_MAX;
        self.y_max = 0;
    }
    return self;
}

- (void)addPixelPositionX:(NSUInteger)x andY:(NSUInteger)y {
    [self.x_arr addObject:[NSNumber numberWithInteger:x]];
    [self.y_arr addObject:[NSNumber numberWithInteger:y]];
    self.x_min = self.x_min < x ? self.x_min : x;
    self.x_max = self.x_max > x ? self.x_max : x;
    self.y_min = self.y_min < y ? self.y_min : y;
    self.y_max = self.y_max > y ? self.y_max : y;
}

- (void)appendPixelsFrom:(CharacterPixels *)characterPixels {
    [self.x_arr addObjectsFromArray:characterPixels.x_arr];
    [self.y_arr addObjectsFromArray:characterPixels.y_arr];
    self.x_min = self.x_min < characterPixels.x_min ? self.x_min : characterPixels.x_min;
    self.x_max = self.x_max > characterPixels.x_max ? self.x_max : characterPixels.x_max;
    self.y_min = self.y_min < characterPixels.y_min ? self.y_min : characterPixels.y_min;
    self.y_max = self.y_max > characterPixels.y_max ? self.y_max : characterPixels.y_max;
}

- (uint32_t *)getPixels {
    NSUInteger height = self.x_max - self.x_min + 1;
    NSUInteger width = self.y_max - self.y_min + 1;
    uint32_t *pixels = (uint32_t *)calloc(width * height, sizeof(uint32_t));
    for (int i = 0; i < [self.x_arr count]; i++) {
        NSUInteger x = [(NSNumber *)[self.x_arr objectAtIndex:i] integerValue] - self.x_min;
        NSUInteger y = [(NSNumber *)[self.y_arr objectAtIndex:i] integerValue] - self.y_min;
        NSUInteger index = width * x + y;
        pixels[index] = 0xFF000000;
    }
    return pixels;
}

@end
