//
//  RecognitionDetailVC.h
//  PDF_OCR
//
//  Created by huijinghuang on 4/22/15.
//  Copyright (c) 2015 huijinghuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecognitionDetailVC : UIViewController

@property (nonatomic) NSUInteger characterNumber;
@property (nonatomic, strong) UIImage *characterImage;
@property (nonatomic, strong) NSArray *propVec;
//@property (nonatomic, strong) UIImage *pdfImage;

@property (strong, nonatomic) IBOutlet UITextView *propVecTextView;
@property (strong, nonatomic) IBOutlet UILabel *characterNumLabel;
@property (strong, nonatomic) IBOutlet UIImageView *characterImgView;
@property (strong, nonatomic) IBOutlet UITextField *correctCharacter;
- (IBAction)okButton:(id)sender;
@end
