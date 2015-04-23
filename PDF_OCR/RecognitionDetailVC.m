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
    
    [self initGUI];
}

- (void)initGUI {
    CGFloat label_x = self.view.frame.size.width/2;
    CGFloat label_y = 50;
    CGFloat label_width = 100;
    CGFloat label_height = 50;
    UILabel* label = [[UILabel alloc] initWithFrame:
                      CGRectMake(label_x, label_y, label_width, label_height)];
    label.backgroundColor = [UIColor yellowColor];
    label.text = [NSString stringWithFormat:@"Character #%d", self.characterNumber];
    
    [self.view addSubview:label];
    self.view.backgroundColor = [UIColor whiteColor];
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
