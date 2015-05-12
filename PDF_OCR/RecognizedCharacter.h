//
//  RecognizedCharacter.h
//  PDF_OCR
//
//  Created by huijinghuang on 5/10/15.
//  Copyright (c) 2015 huijinghuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RecognizedCharacter : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSData * propVector;
@property (nonatomic, retain) NSString * value;

@end
