//
//  RecognitionDetailVC.m
//  PDF_OCR
//
//  Created by huijinghuang on 4/22/15.
//  Copyright (c) 2015 huijinghuang. All rights reserved.
//

#import "RecognitionDetailVC.h"

@interface RecognitionDetailVC ()

@end

@implementation RecognitionDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self initGUI];
    [self setUpGUI];
}

// new code: build GUI with xib file
- (void)setUpGUI {
    self.characterNumLabel.text = [NSString stringWithFormat:@"Character #%lu", (unsigned long)self.characterNumber];
    self.characterImgView.image = self.characterImage;
    NSMutableString *propVecStr = [[NSMutableString alloc] init];
    for (int i = 0; i < [self.propVec count]; i++) {
        [propVecStr appendString:[(NSNumber *)[self.propVec objectAtIndex:i] stringValue]];
        [propVecStr appendString:@"\n"];
    }
    self.propVecTextView.text = propVecStr;
}

- (IBAction)okButton:(id)sender {
    NSString *ch = self.correctCharacter.text;
    NSLog(@"user input: %@", ch);
}

// old code: build GUI with code
- (void)initGUI {
    /**************    1. label    ******************/
    CGFloat label_x = self.view.frame.size.width/2;
    CGFloat label_y = 50;
    CGFloat label_width = 100;
    CGFloat label_height = 50;
    UILabel* label = [[UILabel alloc] initWithFrame:
                      CGRectMake(label_x, label_y, label_width, label_height)];
    label.backgroundColor = [UIColor yellowColor];
    label.text = [NSString stringWithFormat:@"Character #%lu", (unsigned long)self.characterNumber];
    [self.view addSubview:label];
    self.view.backgroundColor = [UIColor whiteColor];
    
    /**************   2. character image   ***************/
    CGFloat x = 50;
    CGFloat y = 300;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y,
                                                                           self.characterImage.size.width, self.characterImage.size.height)];
    imageView.image = self.characterImage;
    // for test, show image border
    [imageView.layer setBorderColor:[[UIColor redColor] CGColor]];
    [imageView.layer setBorderWidth:0.5];
    [self.view addSubview:imageView];
    
    /***********    3. matrix    ***************/
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
