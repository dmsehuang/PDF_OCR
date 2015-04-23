//
//  RecognitionPageVC.m
//  PDF_OCR
//
//  Created by huijinghuang on 4/22/15.
//  Copyright (c) 2015 huijinghuang. All rights reserved.
//

#import "RecognitionPageVC.h"
#import "RecognitionDetailVC.h"

@interface RecognitionPageVC ()

@end

@implementation RecognitionPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.numberOfPages = 5;
    
    RecognitionDetailVC* initialDetailVC = [self viewControllerAtIndex:0];
    NSArray* viewControllers = [NSArray arrayWithObjects:initialDetailVC, nil];
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

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return nil;
}

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    return nil;
}

- (RecognitionDetailVC*)viewControllerAtIndex:(NSUInteger)index {
    RecognitionDetailVC* detailVC = [[RecognitionDetailVC alloc] init];
    detailVC.characterNumber = index;
    return detailVC;
}

@end
