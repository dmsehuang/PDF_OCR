//
//  RecognitionPageVC.h
//  PDF_OCR
//
//  Created by huijinghuang on 4/22/15.
//  Copyright (c) 2015 huijinghuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecognitionPageVC : UIPageViewController <UIPageViewControllerDataSource>

@property (nonatomic) NSUInteger numberOfPages;
@property (nonatomic, strong) UIImage *pdfImage;
@property (nonatomic, strong) NSMutableArray *characterImages;
@property (nonatomic, strong) NSMutableArray *propVectors;

@end
