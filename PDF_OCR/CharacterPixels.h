//
//  CharacterPixels.h
//  PDF_OCR
//
//  Created by huijinghuang on 4/26/15.
//  Copyright (c) 2015 huijinghuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CharacterPixels : NSObject

@property (nonatomic, strong) NSMutableArray *x_arr;
@property (nonatomic, strong) NSMutableArray *y_arr;
@property (nonatomic) NSUInteger x_min;
@property (nonatomic) NSUInteger x_max;
@property (nonatomic) NSUInteger y_min;
@property (nonatomic) NSUInteger y_max;

- (void)addPixelPositionX:(NSUInteger)x andY:(NSUInteger)y;
- (void)appendPixelsFrom:(CharacterPixels *)characterPixels;
- (uint32_t *)getPixels;

@end
