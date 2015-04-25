//
//  Character.m
//  PDF_OCR
//
//  Created by huijinghuang on 4/23/15.
//  Copyright (c) 2015 huijinghuang. All rights reserved.
//

#import "Character.h"

// get R, G, B from uint32_t
#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )

#define bytesPerPixel 4
#define bitsPerComponent 8


@implementation Character

+ (NSArray *)getCharactersFromTextImage:(UIImage *)image {
    return nil;
}

+ (NSString *)getCharacterFromCharacterImage:(UIImage *)image {
    return nil;
}

+ (UIImage *)getBlackNWhiteImageFromImage:(UIImage *)image {
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);

    uint32_t *pixels = [self getPixelsFromImage:image];
    pixels = [self thresholdImagePixels:pixels withSize:width*height];
    UIImage *blackNWhiteImage = [self convertPixels:pixels toImageWithWidt:width andHeight:height];
    return blackNWhiteImage;
}

// get pixels from image, using RGBA32 color space
+ (uint32_t *)getPixelsFromImage:(UIImage *)image {
    // 1 image reference
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    
    // 2 declare parameters and declare, init pixels
    NSUInteger bytesPerRow = bytesPerPixel * width;
    uint32_t *pixels = (uint32_t *) calloc(width * height, sizeof(uint32_t));
    
    // 3 get context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    // 4 draw data to pixels
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    // 5 clean up
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    return pixels;
}

// threshold image
+ (uint32_t *)thresholdImagePixels:(uint32_t *)pixels withSize:(size_t)size {
    CGFloat threshold = 0.5;
    for (int i = 0; i < size; i++) {
        if (R(pixels[i]) + G(pixels[i]) + B(pixels[i]) < 255 * 3 * threshold) {
            pixels[i] = pixels[i] & 0xFF000000; // set 24 bits to 0
        } else {
            pixels[i] = pixels[i] | 0x00FFFFFF; // set 24 bits to 1
        }
    }
    return pixels;
}

// convert pixels back to uiimage
+ (UIImage *)convertPixels:(uint32_t *)pixels toImageWithWidt:(NSUInteger)width andHeight:(NSUInteger)height{
    // the 3rd parameter is the number of bytes data provider has
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, pixels, width * height * 4, NULL);
    
    // parameters
    NSUInteger bytesPerRow = bytesPerPixel * width;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
//    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    CGImageRef imageRef = CGImageCreate(width, height, bitsPerComponent, bytesPerPixel * 8, bytesPerRow, colorSpace, bitmapInfo, dataProvider, NULL, NO, renderingIntent);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(dataProvider);
    
    return image;
}

@end
