//
//  LoginViewController.h
//  TechQuiz
//
//  Created by Preejith Augustine on 11/05/16.
//  Copyright © 2016 Preejith Augustine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>

@property (strong, nonatomic)  UINavigationController *navigationController;

@property (strong,nonatomic) NSString *userName;
@property (strong,nonatomic) NSString *password;


@end
