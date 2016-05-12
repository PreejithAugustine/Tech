//
//  AppDelegate.h
//  TechQuiz
//
//  Created by Preejith Augustine on 11/05/16.
//  Copyright © 2016 Preejith Augustine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "FavouriteViewController.h"
#import "AboutViewController.h"
#import "LogoutViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//for creating tab bar
@property(strong,nonatomic) UITabBarController *tabBarController;

@end

