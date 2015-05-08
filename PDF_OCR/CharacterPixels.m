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
    [self calculatePropVectorWithPixels:pixels withWidth:width andHeight:height];
    return pixels;
}

- (void)calculatePropVectorWithPixels:(uint32_t *)pixels withWidth:(NSUInteger)width andHeight:(NSUInteger)height{
    //NSLog(@"height: %d, width: %d", height, width);
    CGFloat prop_vec[27];
    // calculate property vector for the first 25 properties
    // if height isn't multiply of 5, share the residule among 5 group
    NSUInteger delta_x[5];
    NSUInteger boundary_x[5];
    boundary_x[0] = 0;
    NSUInteger res_x = height % 5;
    for (int i = 0; i < 5; i++) {
        if (res_x > 0) {
            delta_x[i] = height/5 + 1;
            res_x--;
        } else {
            delta_x[i] = height/5;
        }
        if (i > 0) {
            boundary_x[i] = boundary_x[i-1] + delta_x[i-1];
            //NSLog(@"boundary x: %d", boundary_x[i]);
        }
    }
    NSUInteger delta_y[5];
    NSUInteger boundary_y[5];
    boundary_y[0] = 0;
    NSUInteger res_y = width % 5;
    for (int i = 0; i < 5; i++) {
        if (res_y > 0) {
            delta_y[i] = width/5 + 1;
            res_y--;
        } else {
            delta_y[i] = width/5;
        }
        if (i > 0) {
            boundary_y[i] = boundary_y[i-1] + delta_y[i-1];
            //NSLog(@"boundary y: %d", boundary_y[i]);
        }
    }
    // declare vecotr
    NSUInteger black[25];
    NSUInteger white[25];
    // init black and white array
    for (int i = 0; i < 25; i++) {
        black[i] = 0;
        white[i] = 0;
    }
    for (int x = 0; x < height; x++) {
        NSUInteger index = 0;
        if (x >= boundary_x[0] && x < boundary_x[1]) {
            index = 0;
        } else if (x >= boundary_x[1] && x < boundary_x[2]) {
            index = 5;
        } else if (x >= boundary_x[2] && x < boundary_x[3]) {
            index = 10;
        } else if (x >= boundary_x[3] && x < boundary_x[4]) {
            index = 15;
        } else if (x >= boundary_x[4]) {
            index = 20;
        } else {
            NSLog(@"x Index error, %d", x);
        }
        for (int y = 0; y < width; y++) {
            NSUInteger delta_index = 0;
            if (y >= boundary_y[0] && y < boundary_y[1]) {
                delta_index = 0;
            } else if (y >= boundary_y[1] && y < boundary_y[2]) {
                delta_index = 1;
            } else if (y >= boundary_y[2] && y < boundary_y[3]) {
                delta_index = 2;
            } else if (y >= boundary_y[3] && y < boundary_y[4]) {
                delta_index = 3;
            } else if (y >= boundary_y[4]) {
                delta_index = 4;
            } else {
                NSLog(@"y Index error, %d", y);
            }
            // count black and white pixel
            if (pixels[width * x + y] == 0xFF000000) {
                black[index + delta_index]++;
            } else {
                white[index + delta_index]++;
            }
            
        }
    }
    for (int i = 0; i < 25; i++) {
        //NSLog(@"black %d : white %d, index: %d\n\n", black[i], white[i], i);
        prop_vec[i] = (CGFloat)black[i]/(CGFloat)(black[i] + white[i]); // the ratio of black pixels
    }
    prop_vec[25] = (CGFloat)width/(CGFloat)height;
    prop_vec[26] = 0.0; // 0 means not i or j
    self.propertyVector = [[NSMutableArray alloc] init];
    for (int i = 0; i < 27; i++) {
        //NSLog(@"vector %d: %f", i, prop_vec[i]);
        [self.propertyVector addObject:[NSNumber numberWithFloat:prop_vec[i]]];
    }
    return ;
}

@end
