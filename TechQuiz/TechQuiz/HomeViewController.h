//
//  HomeViewController.h
//  TechQuiz
//
//  Created by Pramod Kumar G on 11/05/16.
//  Copyright © 2016 Preejith Augustine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropdownList.h"
#import "UIView+TechCategories.h"
#import <CoreData/CoreData.h>

@interface HomeViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) NSString *questionNo;
@property (nonatomic,strong) NSString *question;
@property (strong, nonatomic) NSString *option1;
@property (strong,nonatomic) NSString *option2;
@property (strong, nonatomic) NSString *option3;
@property (strong,nonatomic) NSString *option4;
@property (strong,nonatomic) NSString *correctAnswer;

@end
