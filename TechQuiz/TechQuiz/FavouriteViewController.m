//
//  FavouriteViewController.m
//  TechQuiz
//
//  Created by Pramod Kumar G on 11/05/16.
//  Copyright © 2016 Preejith Augustine. All rights reserved.
//

#import "FavouriteViewController.h"

@interface FavouriteViewController (){
    float screenWidth;
    float screenHeight;
    float tabBarHeight;
    float statusBarHeight;
    float navBarHeight;
    
    UIView *baseView;
    UIView *topMenuView;
    
    UITextField *questionNoTF;
    UILabel *totalQuestionNolbl;
    
    UIButton *previousbutton;
    UIButton *kbHideButton;
    
    DropdownList *list;
    BOOL listFlag;
    UIView *selectCategoryTF;
    
}

@end

@implementation FavouriteViewController
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.navigationItem setTitle:@"Thec -Quiz"];
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    navBar.barTintColor     = [UIColor grayColor];
    navBar.translucent      = false;
    self.navigationItem.title =@"Tech Quiz";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:18]}];
    self.view.backgroundColor=[UIColor lightGrayColor];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    [self loadIntialView];

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

#pragma mark 

-(void)loadIntialView{
    tabBarHeight    = self.tabBarController.tabBar.frame.size.height;
    navBarHeight    = self.navigationController.navigationBar.frame.size.height;
    statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    screenWidth     = self.view.frame.size.width;
    
    screenHeight    = self.view.frame.size.height-(navBarHeight+tabBarHeight+statusBarHeight);
    baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,screenWidth,screenHeight)];
    baseView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:baseView];
    
    topMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
    topMenuView.backgroundColor = [UIColor whiteColor];
    [baseView addSubview:topMenuView];
    
    UIButton *filterBtn =[[UIButton alloc]initWithFrame:CGRectMake(screenWidth-50,10, 30, 30)];
    [filterBtn setImage:[UIImage imageNamed:@"filter.png"]forState:UIControlStateNormal];
    [filterBtn addTarget:self action:@selector(showList) forControlEvents:UIControlEventTouchUpInside];
    [topMenuView addSubview:filterBtn];
    
    
    UILabel *lblQuestion =[[UILabel alloc]initWithFrame:CGRectMake(20,10, 30, 30)];
    lblQuestion.text= @"Q:";
    lblQuestion.font=[UIFont fontWithName:@"Helvetica" size:20];
    [topMenuView addSubview:lblQuestion];
    
    previousbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [previousbutton addTarget:self
                       action:@selector(previousAction)
             forControlEvents:UIControlEventTouchUpInside];
    previousbutton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:25];
    [previousbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [previousbutton setTitle:@" < " forState:UIControlStateNormal];
    previousbutton.frame = CGRectMake(45.0, 10, 30.0, 30.0);
    [topMenuView addSubview:previousbutton];
    
    UIButton *nextbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextbutton addTarget:self
                   action:@selector(nextAction)
         forControlEvents:UIControlEventTouchUpInside];
    
    nextbutton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:25];
    [nextbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextbutton setTitle:@" > " forState:UIControlStateNormal];
    nextbutton.frame = CGRectMake(screenWidth-170,10,30,30);
    [topMenuView addSubview:nextbutton];
    
    
    questionNoTF  = [[UITextField alloc] initWithFrame:CGRectMake(previousbutton.frame.origin.x+30,10,40,30)];
    questionNoTF.textColor = [UIColor blackColor];
    questionNoTF.delegate = self;
    questionNoTF.keyboardType =UIKeyboardTypeNumberPad;
    [questionNoTF setFont:[UIFont fontWithName:@"Helvetica Neue" size:20]];
    questionNoTF.text=@"1";
    questionNoTF.placeholder = @"1";
    [questionNoTF addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    NSAttributedString *attributedLeftText = [[NSAttributedString alloc] initWithString:questionNoTF.text attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSUnderlineColorAttributeName:[UIColor clearColor]}];
    questionNoTF.attributedText = [attributedLeftText copy];
    questionNoTF.textAlignment=NSTextAlignmentLeft;
    [topMenuView addSubview:questionNoTF];
    
    float leftLabelWidth = [questionNoTF.text boundingRectWithSize:questionNoTF.frame.size
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{ NSFontAttributeName:questionNoTF.font }
                                                           context:nil].size.width;
    
    NSLog(@"the width of yourLabel is %f", leftLabelWidth);
    
    totalQuestionNolbl  = [[UILabel alloc] initWithFrame:CGRectMake(previousbutton.frame.origin.x+35+leftLabelWidth,10,60,30)];
    totalQuestionNolbl.textColor = [UIColor blackColor];
    [totalQuestionNolbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:20]];
    totalQuestionNolbl.text=[NSString stringWithFormat:@"/%@",@"10"];
    totalQuestionNolbl.textAlignment=NSTextAlignmentLeft;
    [topMenuView addSubview:totalQuestionNolbl];
    
    kbHideButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    kbHideButton.backgroundColor = [UIColor clearColor];
    kbHideButton.hidden=true;
    [kbHideButton addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:kbHideButton];
    
    [self loadList];
    
    
    selectCategoryTF=[[UIView alloc]initWithFrame:CGRectMake(20,screenHeight*0.18+3,screenWidth-40, screenHeight*0.09)];
    //selectCategoryTF.delegate = self;
    //    selectCategoryTF.text = NSLocalizedString(@"SELECT_A_CATEGORY",nil);
    //    selectCategoryTF.font = [UIFont fontWithName:@"Helvetica Neue" size:15];
    //    selectCategoryTF.textColor=[UIColor redColor];
    //    selectCategoryTF.backgroundColor=[UIColor redColor];
    selectCategoryTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
    [baseView addSubview: selectCategoryTF];
    
    
    
}

-(void)loadList {
    list = [[DropdownList alloc] init];
    CGRect frame = selectCategoryTF.frame;
    list.parentWidth = selectCategoryTF.frame.size.width;
    list.view.frame = CGRectMake(frame.origin.x, frame.origin.y+frame.size.height, frame.size.width, 0);
    list.dropdownTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    list.dropdownTableView.backgroundColor=[UIColor whiteColor];
    list.dropdownTableView.separatorColor=[UIColor clearColor];
    
    listFlag = true;
    list.delegate = self;
    list.view.clipsToBounds = YES;
    [baseView addSubview:list.view];
    [self addChildViewController:list];
    
}

@end
