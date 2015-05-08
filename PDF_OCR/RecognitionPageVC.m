//
//  RecognitionPageVC.m
//  PDF_OCR
//
//  Created by huijinghuang on 4/22/15.
//  Copyright (c) 2015 huijinghuang. All rights reserved.
//

#import "RecognitionPageVC.h"
#import "RecognitionDetailVC.h"
#import "Character.h"

@interface RecognitionPageVC ()

@end

@implementation RecognitionPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.numberOfPages = 5;
//    self.pdfImage = [UIImage imageNamed:@"1_sample_complete.png"];
//    self.pdfImage = [UIImage imageNamed:@"2_sample_part.png"];
//    self.pdfImage = [UIImage imageNamed:@"6_F.png"];
//    self.pdfImage = [UIImage imageNamed:@"7_Te.png"];
    self.pdfImage = [UIImage imageNamed:@"8_one_line.png"];
    
    self.dataSource = self;
    //self.pageIndex = 0;
    NSArray *imgAndPropVecArr = [Character getCharactersFromTextImage:self.pdfImage];
    self.characterImages = [[NSMutableArray alloc] init];
    self.propVectors = [[NSMutableArray alloc] init];
    // getCharacters will return both images and its corresponding property vectors
    for (int i = 0; i < [imgAndPropVecArr count]; i++) {
        if (i % 2 == 0) {
            [self.characterImages addObject:[imgAndPropVecArr objectAtIndex:i]];
        } else {
            [self.propVectors addObject:[imgAndPropVecArr objectAtIndex:i]];
        }
    }
    RecognitionDetailVC *initialDetailVC = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObjects:initialDetailVC, nil];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
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

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [(RecognitionDetailVC *)viewController characterNumber];
    if (index == 0) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [(RecognitionDetailVC *)viewController characterNumber];
    ++index;
    if (index == [self.characterImages count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (RecognitionDetailVC *)viewControllerAtIndex:(NSUInteger)index {
    if (self.characterImages == nil) {
        return nil;
    }
    //RecognitionDetailVC *detailVC = [[RecognitionDetailVC alloc] init];
    RecognitionDetailVC *detailVC = [[RecognitionDetailVC alloc] initWithNibName:@"RecognitionDetailView" bundle:nil];
    detailVC.characterNumber = index;
    detailVC.characterImage = [self.characterImages objectAtIndex:index];
    detailVC.propVec = [self.propVectors objectAtIndex:index];
    return detailVC;
}

@end
