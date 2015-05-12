//
//  CharacterDetailView.m
//  PDF_OCR
//
//  Created by huijinghuang on 5/12/15.
//  Copyright (c) 2015 huijinghuang. All rights reserved.
//

#import "CharacterDetailView.h"

@interface CharacterDetailView ()

@end

@implementation CharacterDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.charLabel.text = self.character;
    self.imageView.image = self.characterImage;
    
    NSMutableString *propVecStr = [[NSMutableString alloc] init];
    for (int i = 0; i < [self.propVec count]; i++) {
        [propVecStr appendString:[(NSNumber *)[self.propVec objectAtIndex:i] stringValue]];
        [propVecStr appendString:@"\n"];
    }
    self.propVecText.text = propVecStr;
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
