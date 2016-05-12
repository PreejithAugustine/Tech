//
//  AppDelegate.m
//  TechQuiz
//
//  Created by Preejith Augustine on 11/05/16.
//  Copyright © 2016 Preejith Augustine. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    /* Initialize window view */
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
//    
//     //Initialize tab bar controller, add tabs controllers
//    self.tabBarController = [[UITabBarController alloc] init];
//    self.tabBarController.viewControllers = [self initializeTabBarItems];
//    self.window.rootViewController = self.tabBarController;
//    
//    [self.window makeKeyAndVisible];
//    
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - tab bar method
- (NSArray *)initializeTabBarItems
{
    NSArray * retval;
    
    NSLog(@"hell oooo");
    
    /* Initialize view controllers */
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    FavouriteViewController *favouriteViewController = [[FavouriteViewController alloc] init];
    AboutViewController *aboutViewController = [[AboutViewController alloc] init];
    LogoutViewController *logoutViewController = [[LogoutViewController alloc] init];
    
    
    UINavigationController * navigationController1 = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    UINavigationController * navigationController2 = [[UINavigationController alloc] initWithRootViewController:favouriteViewController];
    UINavigationController * navigationController3 = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
    UINavigationController * navigationController4 = [[UINavigationController alloc] initWithRootViewController:logoutViewController];
    
    
    [navigationController1.navigationBar setBackgroundImage:[UIImage imageNamed: @"NavigationBarBackGroundImage.png"] forBarMetrics:UIBarMetricsDefault];
    self.tabBarController = [[UITabBarController alloc]init];
    self.tabBarController.viewControllers = @[navigationController1,navigationController2,navigationController3,navigationController4];
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    
    
    
    
    // Setting tabbar item title
    tabBarItem1.title = @"Tab1";
    tabBarItem2.title = @"Tab2";
    tabBarItem3.title = @"Tab3";
    tabBarItem4.title = @"Tab4";
    
    //[tabBarItem1 setFinishedSelectedImage:[UIImage imageNamed:@"favorite_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"favorite.png"]];
    //    [tabBarItem1 setFinishedSelectedImage:[UIImage imageNamed:@"favorite_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"favorite.png"]];
    
    
    
    /* Stuff Navigation Controllers into return value */
   // retval = [NSArray arrayWithObjects:favoriteViewController,homeViewController,profileViewController,nil];
    
    
    
    return (retval);
}


@end
