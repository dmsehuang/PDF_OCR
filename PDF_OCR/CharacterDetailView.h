//
//  CharacterDetailView.h
//  PDF_OCR
//
//  Created by huijinghuang on 5/12/15.
//  Copyright (c) 2015 huijinghuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharacterDetailView : UIViewController

@property (strong, nonatomic) UIImage* characterImage;
@property (strong, nonatomic) NSArray *propVec;
@property (strong, nonatomic) NSString *character;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *propVecText;
@property (strong, nonatomic) IBOutlet UILabel *charLabel;

@end
