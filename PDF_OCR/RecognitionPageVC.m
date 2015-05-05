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
//    self.pdfImage = [UIImage imageNamed:@"7_Te.png"];
    self.pdfImage = [UIImage imageNamed:@"8_one_line.png"];
    
    self.dataSource = self;
    self.pageIndex = 0;
    self.characterImages = [Character getCharactersFromTextImage:self.pdfImage];
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
//    NSLog(@"before");
    if (self.pageIndex == 0) {
        return nil;
    }
    self.pageIndex--;
    return [self viewControllerAtIndex:self.pageIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
//    NSLog(@"after, count: %d", [self.characterImages count]);
    if (self.pageIndex + 1 == [self.characterImages count]) {
        return nil;
    }
    self.pageIndex++;
    return [self viewControllerAtIndex:self.pageIndex];
}

- (RecognitionDetailVC *)viewControllerAtIndex:(NSUInteger)index {
//    NSLog(@"Get veiw controller at index");
    if (self.characterImages == nil) {
        return nil;
    }
    RecognitionDetailVC *detailVC = [[RecognitionDetailVC alloc] init];
    detailVC.characterNumber = index;
    detailVC.characterImage = [self.characterImages objectAtIndex:index];
//    NSLog(@"before return: veiw controller at index");
    return detailVC;
}

@end
