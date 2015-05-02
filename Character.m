//
//  Character.m
//  PDF_OCR
//
//  Created by huijinghuang on 4/23/15.
//  Copyright (c) 2015 huijinghuang. All rights reserved.
//

#import "Character.h"
#import "CharacterPixels.h"

// get R, G, B from uint32_t
#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )

#define bytesPerPixel 4
#define bitsPerComponent 8


@implementation Character

+ (NSArray *)getCharactersFromTextImage:(UIImage *)image {
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    
    uint32_t *pixels = [self getPixelsFromImage:image];
    pixels = [self thresholdImagePixels:pixels withSize:width*height];
    NSArray *lines = [self LineDetectionForPixels:pixels withWidth:width andHeight:height];
    NSUInteger topLine = [(NSNumber *)[lines objectAtIndex:2] integerValue];
    NSUInteger bottomLine = [(NSNumber *)[lines objectAtIndex:3] integerValue];
    NSArray *characterImages = [self connectedComponentFromPixels:pixels withWidth:width betweenTopLine:topLine andBottomLine:bottomLine];
    return characterImages;
}

+ (NSString *)getCharacterFromCharacterImage:(UIImage *)image {
    return nil;
}

// OCR - line detection
// TODO - deal with special case: i, j
+ (NSArray *)LineDetectionForPixels:(uint32_t *)pixels
                          withWidth:(NSUInteger)width andHeight:(NSUInteger)height{
    // lines array used to store all detected lines
    NSMutableArray* lines = [NSMutableArray arrayWithCapacity:height];
    bool top = false;
    int* horiArr = (int*) calloc(height, sizeof(int));
    for (int i = 0; i < height; i++) {
        int blackPixel = 0;
        for (int j = 0; j < width; j++) {
            NSUInteger index = width * i + j;
            if (R(pixels[index]) == 0) {
                blackPixel++;
            }
        }
        horiArr[i] = blackPixel;
        
        if (blackPixel > 0) {
            if (!top || i == height-1) {
                // last black pixel should also be in
                [lines addObject:[NSNumber numberWithInt:i]];
                top = true;
                /*
                 // draw line to test
                 for (int j = 0; j < width; j++) {
                 NSUInteger index = width * i + j;
                 pixels[index] = 0xFFFF6666;
                 }
                 */
                
            }
        } else {
            if (top) {
                [lines addObject:[NSNumber numberWithInt:i]];
                top = false;
                /*
                 // draw line to test
                 for (int j = 0; j < width; j++) {
                 NSUInteger index = width * i + j;
                 pixels[index] = 0xFFFF6666;
                 }
                 */
            }
        }
    }
    free(horiArr); // free memory after use
    // for test
    //UIImage *image = [self convertPixels:pixels toImageWithWidth:width andHeight:height];
    //return image;
    
    return [NSArray arrayWithArray:lines];
}

// OCR - connected component
+ (NSArray *)connectedComponentFromPixels:(uint32_t *)pixels withWidth:(NSUInteger)width
                           betweenTopLine:(NSUInteger)topLine andBottomLine:(NSUInteger)bottomLine {
    /* 
                            step 1: ASSIGN LABEL
    algorithm: label starts with 1,
    check 8 neighbors (actually 4) and assign the min label to the current position
    if no label is found, assign a new label to it
     */
    
    NSUInteger parent[width];
    NSUInteger height = bottomLine - topLine + 1;
    NSUInteger labelArr[height][width]; // C style
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSLog(@"%d", height);
    NSLog(@"%d", width);
    for (int i = 0; i < height; i++) {
        NSString *line = [NSString stringWithFormat:@""];
        for (int j = 0; j < width; j++) {
            labelArr[i][j] = 0; // zero means not assigned
            NSUInteger index = width * i + j;
            if (R(pixels[index]) == 255) {
                line = [line stringByAppendingString:@" "];
            } else {
                line = [line stringByAppendingString:@"*"];
            }
        }
//        NSLog(@"%@", line);
    }
    
    NSUInteger labelCount = 0; // label begins with 1
    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            NSUInteger index = width * i + j;
            // TODO - this logic need to be modified
            if (R(pixels[index]) == 255) continue; // skip white pixel
            
            // step 1.1: search for the min label
            NSInteger minLabel = 0; // 0 means can't find
            NSInteger xcorrd[4] = {i, i-1, i-1, i-1};
            NSInteger ycoord[4] = {j-1, j-1, j, j+1};
            for (int k = 0; k < 4; k++) {
                NSInteger x = xcorrd[k];
                NSInteger y = ycoord[k];
                if (x < 0 || x >= height) continue;
                if (y < 0 || y >= width) continue;
                if (labelArr[x][y] == 0) continue; // not assigned value yet
                if (minLabel == 0) minLabel = labelArr[x][y];
                else minLabel = minLabel < labelArr[x][y] ? minLabel : labelArr[x][y];
            }
            
            // step 1.2: assign value to current pixel
            if (minLabel == 0) {
                ++labelCount;
                labelArr[i][j] = labelCount;
                parent[labelCount] = labelCount; // set self as the parent
                CharacterPixels *ch_pixels = [[CharacterPixels alloc] init];
                [ch_pixels addPixelPositionX:i andY:j];
                [dict setObject:ch_pixels forKey:[NSNumber numberWithInteger:labelCount]];
            } else {
                labelArr[i][j] = minLabel;
                CharacterPixels *ch_pixels = [dict objectForKey:[NSNumber numberWithInteger:minLabel]];
                [ch_pixels addPixelPositionX:i andY:j];
                [dict setObject:ch_pixels forKey:[NSNumber numberWithInteger:minLabel]];
            }
            
            // step 1.3: update parent
            for (int k = 0; k < 4; k++) {
                NSInteger x = xcorrd[k];
                NSInteger y = ycoord[k];
                if (x < 0 || x >= height) continue;
                if (y < 0 || y >= width) continue;
                if (labelArr[x][y] == 0) continue;
                
//                if (parent[labelArr[x][y]] != minLabel) {
//                    NSLog(@"%d, %d", x, y);
//                    for (int z = 0; z < 4; z++) {
//                        NSInteger xz = xcorrd[z];
//                        NSInteger yz = ycoord[z];
//                        NSLog(@"label[%d][%d] = %d", xz, yz, labelArr[xz][yz]);
//                    }
//                    NSLog(@"label: %d, (min label) parent %d", labelArr[x][y], minLabel);
//                }
                NSUInteger oldParent = parent[labelArr[x][y]];
                parent[labelArr[x][y]] = oldParent < minLabel ? oldParent : minLabel;
            }
        }
    }
    
    NSMutableString* test = [[NSMutableString alloc] initWithString:@"\n"];
    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            if (labelArr[i][j] == 0) {
                [test appendString:@" "];
            } else {
                [test appendString:[NSString stringWithFormat:@"%d", (int)labelArr[i][j]]];
            }
        }
        [test appendString:@"\n"];
    }
    NSLog(@"test result");
    NSLog(@"%@", test);
    
    
    /*
                step 2: MERGE LABEL
    should use weighted quick-union, but the tree is flat in this case
    so quick union is quick enough
     */
    
    // step 2.1 find root
    for (int i = 1; i <= labelCount; i++) {
        NSInteger j = i;
        while (parent[j] != j) {
            j = parent[j];
        }
        parent[i] = j;
    }
    
    // step 2.2 merge
    for (id key in dict) {
        int label = [(NSNumber *)key intValue];
        if (parent[label] != label) {
            CharacterPixels *parent_pixels = [dict objectForKey:[NSNumber numberWithInteger:parent[label]]];
            CharacterPixels *child_pixels = [dict objectForKey:key];
            [parent_pixels appendPixelsFrom:child_pixels];
        }
    }
    
    // step 2.3
    NSMutableArray *characterImages = [[NSMutableArray alloc] init];
    for (int i = 1; i <= labelCount; i++) {
        if (parent[i] == i) {
            CharacterPixels *ch_pixels = [dict objectForKey:[NSNumber numberWithInt:i]];
            uint32_t *pixels = [ch_pixels getPixels];
            NSUInteger ch_height = ch_pixels.x_max - ch_pixels.x_min;
            NSUInteger ch_width = ch_pixels.y_max - ch_pixels.y_min;
            UIImage *ch_image = [self convertPixels:pixels toImageWithWidth:ch_width andHeight:ch_height];
            [characterImages addObject:ch_image];
        }
    }
    return characterImages;
//    return nil;
}

// get pure black and white image from original image
+ (UIImage *)getBlackNWhiteImageFromImage:(UIImage *)image {
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);

    uint32_t *pixels = [self getPixelsFromImage:image];
    pixels = [self thresholdImagePixels:pixels withSize:width*height];
    UIImage *blackNWhiteImage = [self convertPixels:pixels toImageWithWidth:width andHeight:height];
    return blackNWhiteImage;
    
    // test line
    //UIImage *imageWithLine = [self LineDetectionForPixels:pixels withWidth:width andHeight:height];
    //return imageWithLine;
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
+ (UIImage *)convertPixels:(uint32_t *)pixels toImageWithWidth:(NSUInteger)width andHeight:(NSUInteger)height{
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
