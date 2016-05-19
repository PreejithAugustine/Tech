//
//  FavouriteViewController.h
//  TechQuiz
//
//  Created by Pramod Kumar G on 11/05/16.
//  Copyright © 2016 Preejith Augustine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropdownList.h"
#import "HomeViewController.h"
#import <CoreData/CoreData.h>


@interface FavouriteViewController : UIViewController

@property (nonatomic,strong) NSString *questionNo;
@property (nonatomic,strong) NSString *question;
@property (strong, nonatomic) NSString *option1;
@property (strong,nonatomic) NSString *option2;
@property (strong, nonatomic) NSString *option3;
@property (strong,nonatomic) NSString *option4;
@property (strong,nonatomic) NSString *correctAnswer;
@property (strong,nonatomic) NSString *favouriteState;
@property (strong, nonatomic) UIButton *favouriteButton;
@property (strong,nonatomic) NSMutableArray *favouriteStateArray;
@property (strong,nonatomic) NSMutableArray *questionArray;
@property (strong,nonatomic) NSMutableArray *option1Array;
@property (strong,nonatomic) NSMutableArray *option2Array;
@property (strong,nonatomic) NSMutableArray *option3Array;
@property (strong,nonatomic) NSMutableArray *option4Array;
@property (strong,nonatomic) NSMutableArray *correctAnswerArray;
@property (strong,nonatomic) NSMutableArray *questionCategoryArray;

@end