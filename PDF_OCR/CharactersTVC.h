//
//  CharactersTVC.h
//  PDF_OCR
//
//  Created by huijinghuang on 4/22/15.
//  Copyright (c) 2015 huijinghuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "RecognizedCharacter.h"
#import "CharacterDetailView.h"

@interface CharactersTVC : UITableViewController

@property (nonatomic, strong) UINavigationController *navi;
@property (nonatomic, strong) NSArray *recognizedCharArr;

@end
