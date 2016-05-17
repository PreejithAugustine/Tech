//
//  AboutViewController.m
//  TechQuiz
//
//  Created by Pramod Kumar G on 11/05/16.
//  Copyright © 2016 Preejith Augustine. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController (){
    float screenWidth;
    float screenHeight;
    float tabBarHeight;
    float statusBarHeight;
    float navBarHeight;
    
    UIView *baseView;
}

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"Thech - Quiz"];
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    navBar.barTintColor     = [UIColor darkGrayColor];
    navBar.translucent      = false;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:18]}];
    self.view.backgroundColor=[UIColor lightGrayColor];
    [self loadIntialView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadIntialView{
    
    tabBarHeight    = self.tabBarController.tabBar.frame.size.height;
    navBarHeight    = self.navigationController.navigationBar.frame.size.height;
    statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    screenWidth     = self.view.frame.size.width;
    screenHeight    = self.view.frame.size.height-(navBarHeight+tabBarHeight+statusBarHeight);
    baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,screenWidth,screenHeight)];
    baseView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:baseView];
    
   UILabel *aboutAppLbl=[[UILabel alloc]initWithFrame:CGRectMake(10,10,screenWidth-20,80)];
    aboutAppLbl.text=@"An app for understanding the technical knowledge on different topics .";
    aboutAppLbl.lineBreakMode = NSLineBreakByWordWrapping;
    aboutAppLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:18
                          ];
    aboutAppLbl.numberOfLines=3;
    aboutAppLbl.textAlignment=NSTextAlignmentLeft;
    [baseView addSubview:aboutAppLbl];
    
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,100,100)];
    logoImageView.center = CGPointMake(screenWidth/2, screenHeight/2);
    logoImageView.backgroundColor=[UIColor whiteColor];
    logoImageView.image = [UIImage imageNamed:@"quiz.jpg"];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [baseView addSubview:logoImageView];
    
    
    NSString * correctAnswerIndex =@"Version";
    NSString * correctAnswerStr =@"1.0.0";
    NSString *answertext = [NSString stringWithFormat:@"%@: %@", correctAnswerIndex, correctAnswerStr];
    UILabel *versionLbl=[[UILabel alloc]initWithFrame:CGRectMake(10,10,screenWidth-20,80)];
    versionLbl.center = CGPointMake(screenWidth/2, screenHeight/2+70);
    versionLbl.text=answertext;
    versionLbl.lineBreakMode = NSLineBreakByWordWrapping;
    versionLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:18
                        ];
    versionLbl.numberOfLines=1;
    versionLbl.textAlignment=NSTextAlignmentCenter;
    [baseView addSubview:versionLbl];


    

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
