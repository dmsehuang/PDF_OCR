//
//  Character.h
//  PDF_OCR
//
//  Created by huijinghuang on 4/23/15.
//  Copyright (c) 2015 huijinghuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Character : NSObject

/* This is the main class that deals with character recognition, factory methods */

// receive an image of text and return images of all characters
+ (NSArray *)getCharactersFromTextImage:(UIImage *)image;

// receive an image of a character and return the character as text
+ (NSString *)getCharacterFromCharacterImage:(UIImage *)image;

// get black and white image from colorful image
+ (UIImage *)getBlackNWhiteImageFromImage:(UIImage *)image;

// receive an image of text and return images of words

+ (UIImage *)convertPixels:(uint32_t *)pixels toImageWithWidth:(NSUInteger)width andHeight:(NSUInteger)height;

@end
