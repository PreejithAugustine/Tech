//
//  HomeViewController.m
//  TechQuiz
//
//  Created by Pramod Kumar G on 11/05/16.
//  Copyright © 2016 Preejith Augustine. All rights reserved.
//

#import "HomeViewController.h"
#import "UIView+Toast.h"
#import "DropDown.h"

@interface HomeViewController (){
    float screenWidth;
    float screenHeight;
    float tabBarHeight;
    float statusBarHeight;
    float navBarHeight;
    
    UIView *baseView;
    UIView *topMenuView;
    UIView *selectCategoryTF;
    UIView *correctAnswerView;
    
    UITextField *questionNoTF;
    UILabel *totalQuestionNolbl;
    UILabel *questionNolbl;
    UILabel *questiontextlbl;
    UILabel *answer;
    UILabel *answerIndicatorLabel;
    UILabel *answertextlbl;
    
    UIButton *previousbutton;
    UIButton *kbHideButton;
    UIButton *answerButton;
   
    BOOL listFlag;
    
    UIScrollView *homeScrollView;
    UITableView *tableViews;
    
    int tableSelected;
    int selectedIndexPath;
    
    NSArray *questionNoArray;
    NSArray *questionArray;
    NSArray *option1Array;
    NSArray *option2Array;
    NSArray *option3Array;
    NSArray *option4Array;
    NSArray *correctAnswerArray;
    NSArray *questionCategoryArray;
    NSArray *correspondingCategoryArray;
    
    NSInteger  questionNumberCount;
    NSInteger  questionNumberInt;
    NSMutableArray *optionsAry;
    
    NSString *answertext;
    
    DropDown *dropDownTable;
    NSString *strSelectedCategories;
  
    NSMutableArray *questionSelectArray;
    NSMutableArray *favoriteStateSelectArray;
    NSMutableArray *option1SelectArray;
    NSMutableArray *option2SelectArray;
    NSMutableArray *option3SelectArray;
    NSMutableArray *option4SelectArray;
    NSMutableArray *correctAnswerSelectArray;
    NSMutableArray *questionCategorySelectArray;
    NSMutableArray *correspondingCategorySelectArray;
    
    NSInteger flagDropDownSelected;
    
    
    
    
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self populateArray];
    [self.navigationItem setTitle:@"Home"];
    
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    navBar.barTintColor     = [UIColor darkGrayColor];
    navBar.translucent      = false;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:18]}];
    self.view.backgroundColor=[UIColor lightGrayColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [self loadIntialView];
    
}


-(void)loadIntialView{
    tabBarHeight    = self.tabBarController.tabBar.frame.size.height;
    navBarHeight    = self.navigationController.navigationBar.frame.size.height;
    statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    screenWidth     = self.view.frame.size.width;
    screenHeight    = self.view.frame.size.height-(navBarHeight+tabBarHeight+statusBarHeight);
    
    questionNumberCount=0;
    tableSelected=0;
    strSelectedCategories=@"Intial";
    
   questionSelectArray =[[NSMutableArray alloc]init];
   option1SelectArray= [[NSMutableArray alloc]init];
   option2SelectArray =[[NSMutableArray alloc]init];
   option3SelectArray =[[NSMutableArray alloc]init];
   option4SelectArray =[[NSMutableArray alloc]init];
   correctAnswerSelectArray =[[NSMutableArray alloc]init];
   questionCategorySelectArray =[[NSMutableArray alloc]init];
   correspondingCategorySelectArray =[[NSMutableArray alloc]init];
   favoriteStateSelectArray=[[NSMutableArray alloc]init];
    
    [self fetchUsingCoreData:questionNumberCount];
    
    baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,screenWidth,screenHeight)];
    baseView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:baseView];
    
    topMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
    topMenuView.backgroundColor = [UIColor whiteColor];
    [baseView addSubview:topMenuView];

    UIButton *filterBtn =[[UIButton alloc]initWithFrame:CGRectMake(screenWidth-50,10, 30, 30)];
    [filterBtn setImage:[UIImage imageNamed:@"filter.png"]forState:UIControlStateNormal];
    [filterBtn addTarget:self action:@selector(showCategoryList) forControlEvents:UIControlEventTouchUpInside];
    [topMenuView addSubview:filterBtn];
    
    
    if ([_favouriteState isEqualToString:@"false"]) {
        _favouriteButton =[[UIButton alloc]initWithFrame:CGRectMake(screenWidth-90,10, 30, 30)];
    [_favouriteButton setImage:[UIImage imageNamed:@"Heart2.png"]forState:UIControlStateNormal];
    [_favouriteButton addTarget:self action:@selector(favoriteAction) forControlEvents:UIControlEventTouchUpInside];
        [topMenuView addSubview:_favouriteButton];}
    else{
        _favouriteButton =[[UIButton alloc]initWithFrame:CGRectMake(screenWidth-90,10, 30, 30)];
        [_favouriteButton setImage:[UIImage imageNamed:@"heart.png"]forState:UIControlStateNormal];
        [_favouriteButton addTarget:self action:@selector(favoriteAction) forControlEvents:UIControlEventTouchUpInside];
        [topMenuView addSubview:_favouriteButton];
    }
    
    UILabel *lblQuestion =[[UILabel alloc]initWithFrame:CGRectMake(20,10, 30, 30)];
    lblQuestion.text= @"Q:";
    lblQuestion.font=[UIFont fontWithName:@"Helvetica" size:20];
    [topMenuView addSubview:lblQuestion];
    
    previousbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [previousbutton addTarget:self action:@selector(previousAction)forControlEvents:UIControlEventTouchUpInside];
    previousbutton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:25];
    [previousbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [previousbutton setTitle:@" < " forState:UIControlStateNormal];
    previousbutton.frame = CGRectMake(45.0, 10, 30.0, 30.0);
    [topMenuView addSubview:previousbutton];
    
    UIButton *nextbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextbutton addTarget:self action:@selector(nextAction)
         forControlEvents:UIControlEventTouchUpInside];
        nextbutton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:25];
    [nextbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextbutton setTitle:@" > " forState:UIControlStateNormal];
    nextbutton.frame = CGRectMake(screenWidth-170, 10,30,30);
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
    totalQuestionNolbl  = [[UILabel alloc] initWithFrame:CGRectMake(previousbutton.frame.origin.x+35+leftLabelWidth,10,60,30)];
    totalQuestionNolbl.textColor = [UIColor blackColor];
    [totalQuestionNolbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:20]];
    totalQuestionNolbl.text=[NSString stringWithFormat:@"/ %lu",(unsigned long)[questionNoArray count]];
    totalQuestionNolbl.textAlignment=NSTextAlignmentLeft;
    [topMenuView addSubview:totalQuestionNolbl];
    
    homeScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,topMenuView.frame.size.height,screenWidth,screenHeight-50)];
    homeScrollView.showsVerticalScrollIndicator=YES;
    homeScrollView.scrollEnabled=YES;
    homeScrollView.userInteractionEnabled=YES;
    homeScrollView.contentSize = CGSizeMake(screenWidth,screenHeight+80);
    homeScrollView.bounces = false;
    homeScrollView.backgroundColor=[UIColor lightGrayColor];
    [baseView addSubview:homeScrollView];
    
    [self fetchUsingCoreData:questionNumberCount];
    
    questionNumberInt=questionNumberCount;
    NSString *questions = [NSString stringWithFormat:@"%d, %@", questionNumberInt+1, _question];
     questiontextlbl.text=questions;
    questiontextlbl=[[UILabel alloc]initWithFrame:CGRectMake(10,10,screenWidth-20,100)];
    questiontextlbl.text=questions;
    questiontextlbl.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize maximumSize = CGSizeMake(questiontextlbl.frame.size.width, MAXFLOAT);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:questiontextlbl.text];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [attributedString setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, attributedString.length)];
    [attributedString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:16]} range:NSMakeRange(0, attributedString.length)];
    CGSize expectedSize = [attributedString boundingRectWithSize:maximumSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    questiontextlbl.numberOfLines =(expectedSize.height/20)+1;
    questiontextlbl.frame=CGRectMake(10,10,screenWidth-20,20*(expectedSize.height/20)+20);
    questiontextlbl.textAlignment=NSTextAlignmentLeft;
    [questiontextlbl setTextColor:[UIColor blackColor]];
    [homeScrollView addSubview:questiontextlbl];
    
    UIView * answerOptionsView=[[UIView alloc]initWithFrame:CGRectMake(10,questiontextlbl.frame.size.height+20,screenWidth-20 ,200)];
    [homeScrollView addSubview:answerOptionsView];
    
    tableViews = [self makeTableView];
    [tableViews registerClass:[UITableViewCell class] forCellReuseIdentifier:@"techQuizTable"];
    [answerOptionsView addSubview:tableViews];
    
    selectCategoryTF=[[UIView alloc]initWithFrame:CGRectMake(20,screenHeight*0.18+3,screenWidth-40, screenHeight*0.09)];
    selectCategoryTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
    [baseView addSubview: selectCategoryTF];

    answerIndicatorLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,answerOptionsView.frame.origin.y+answerOptionsView.frame.size.height+10, 150,40)];
    answerIndicatorLabel.backgroundColor = [UIColor redColor];
    answerIndicatorLabel.hidden = TRUE;
    answerIndicatorLabel.layer.cornerRadius = 10;
    answerIndicatorLabel.clipsToBounds = YES;
    [answerIndicatorLabel setBackgroundColor:[UIColor whiteColor]];
    [homeScrollView addSubview:answerIndicatorLabel];
    
    correctAnswerView=[[UIView alloc]initWithFrame:CGRectMake(10, answerIndicatorLabel.frame.origin.y+answerIndicatorLabel.frame.size.height+10, screenWidth-20, 80)];
     correctAnswerView.backgroundColor=[UIColor whiteColor];
    correctAnswerView.hidden=TRUE;
    correctAnswerView.layer.cornerRadius=10;
    correctAnswerView.clipsToBounds=YES;
       [homeScrollView addSubview:correctAnswerView];
    
    NSString * correctAnswerIndex =@"Correct Answer for the above is ";
    NSString * correctAnswerStr =@"Dennis Ritchie";
    answertext = [NSString stringWithFormat:@"%@, %@", correctAnswerIndex, correctAnswerStr];
    
    answertextlbl=[[UILabel alloc]initWithFrame:CGRectMake(10,-10,screenWidth-20,80)];
    answertextlbl.text=answertext;
    answertextlbl.lineBreakMode = NSLineBreakByWordWrapping;
    answertextlbl.font = [UIFont fontWithName:@"Helvetica Neue" size:18
                          ];
    answertextlbl.numberOfLines=3;
    answertextlbl.textAlignment=NSTextAlignmentLeft;
    [correctAnswerView addSubview:answertextlbl];
 
    kbHideButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    kbHideButton.backgroundColor = [UIColor clearColor];
    kbHideButton.hidden=true;
    [kbHideButton addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:kbHideButton];
    [baseView bringSubviewToFront:kbHideButton];
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [baseView addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [baseView addGestureRecognizer:swiperight];

}



#pragma mark -  Text Field delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidChange {
        if (![questionNoTF.text isEqualToString:@""]) {
        NSAttributedString *attributedLeftText = [[NSAttributedString alloc] initWithString:questionNoTF.text attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSUnderlineColorAttributeName:[UIColor clearColor]}];
        questionNoTF.attributedText = [attributedLeftText copy];
        float leftLabelWidth = [questionNoTF.text boundingRectWithSize:questionNoTF.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:questionNoTF.font } context:nil] .size.width;
        totalQuestionNolbl.frame=CGRectMake(previousbutton.frame.origin.x+35+leftLabelWidth,10,60,30);
            
    }
    
}


- (void)showCategoryList {
   
    dropDownTable=[[DropDown alloc] init];
    UIView *tableView=[dropDownTable tableView :questionCategoryArray];
     tableView.frame= CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height+(navBarHeight+tabBarHeight+statusBarHeight));
    
    dropDownTable.closeButton.frame=CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height+(navBarHeight+tabBarHeight+statusBarHeight));
    dropDownTable.dropDownTableViews.frame=CGRectMake(screenWidth*0.5,navBarHeight+statusBarHeight+topMenuView.frame.size.height,screenWidth*0.5,150);
    dropDownTable.delegate=self;
  
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:tableView];
    
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    kbHideButton.hidden=false;
}

- (void)dismissKeyboard {
    [questionNoTF resignFirstResponder];
    [homeScrollView setContentOffset:CGPointZero animated:YES];
    kbHideButton.hidden=true;

    NSInteger intQuestionNo =[questionNoTF.text integerValue];
    if (intQuestionNo==0) {
        [homeScrollView makeToast:@"Enter a valid question Number"
         ];
    }
    else if(intQuestionNo >[questionNoArray count]){
        [homeScrollView makeToast:@"Enter a valid question Number"
         ];
    }
    else{
    questionNumberCount=intQuestionNo-1;
    [self fetchUsingCoreData:questionNumberCount];
    questionNumberInt=questionNumberCount+1;
    questionNoTF.text=[NSString stringWithFormat:@"%d", questionNumberInt];
    NSString *questions = [NSString stringWithFormat:@"%d, %@", questionNumberInt, _question];
    questiontextlbl.text=questions;
    tableSelected=0;
    answerButton.hidden=TRUE;
    answerIndicatorLabel.hidden=TRUE;
    [tableViews reloadData];
    }
}



#pragma  mark


-(void)favoriteAction{
    NSLog(@"Favourite Action clicked");
    NSLog(@"_favouriteState = %@",_favouriteState);
    
    if ([ _favouriteState isEqualToString: @"false"]){
        [  _favouriteButton setImage:[UIImage imageNamed:@"heart.png" ] forState:UIControlStateNormal];
                _favouriteState = @"true";
        NSManagedObjectContext *context = [self managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"QuestionsKit" inManagedObjectContext:context]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"question = %@",_question];
        [request setPredicate:predicate];
        
        NSError  *error = nil;
        NSArray *results = [context executeFetchRequest:request error:&error];
        
        NSManagedObject *favoritsGrabbed = [results objectAtIndex:0];
        [favoritsGrabbed setValue:@"true" forKey:@"favouriteState"];
        
        if (![context save:&error]) {
            NSLog(@"Cant Save! %@ %@", error, [error localizedDescription]);
        }
        
    }
    else if ([_favouriteState isEqualToString:@"true"])
    {
        [_favouriteButton setImage:[UIImage imageNamed:@"Heart2.png" ] forState:UIControlStateNormal];
        _favouriteState = @"false";
        NSManagedObjectContext *context = [self managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"QuestionsKit" inManagedObjectContext:context]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"question = %@",_question];
        [request setPredicate:predicate];
        NSError  *error = nil;
        NSArray *results = [context executeFetchRequest:request error:&error];
        NSManagedObject *favoritsGrabbed = [results objectAtIndex:0];
        [favoritsGrabbed setValue:@"false" forKey:@"favouriteState"];
        if (![context save:&error]) {
            NSLog(@"Cant Save! %@ %@", error, [error localizedDescription]);
        }
    }
}


-(void) previousAction{
   NSLog(@"countofQnext %d",questionNumberCount);
    if (questionNumberCount>0) {
        questionNumberCount=   questionNumberCount-1;
        [self nextquestions];
    }else{
        [self.tabBarController.view makeToast:@"You have reached to minimum limits"
         
         ];
    }
}
-(void) nextAction{
    NSLog(@"countofQnext %d",questionNumberCount);
    if(flagDropDownSelected==0){
    if (questionNumberCount <[questionNoArray count]-1) {
         questionNumberCount=   questionNumberCount+1;
        [self nextquestions];
    }
    else{
        [self.tabBarController.view makeToast:@"You have reached to maximum limits"
         ];
        
    }
    }
    else{
        if (questionNumberCount <[questionCategorySelectArray count]-1) {
            questionNumberCount=   questionNumberCount+1;
            [self nextquestions];
        }
        else{
            [self.tabBarController.view makeToast:@"You have reached to maximumlimits"
             ];
            
        }
    }

}


-(void)nextquestions{

    if(flagDropDownSelected==1)
    {
        [self fetchUsingCoreData:0];
        [self displaySelectedCategories:questionNumberCount];
    }
    else{
         [self fetchUsingCoreData:questionNumberCount];
    }
    
   
    NSLog(@"Favourite state in next questions = %@",_favouriteState);
    if ([ _favouriteState isEqualToString: @"false"])
    {
        [  _favouriteButton setImage:[UIImage imageNamed:@"Heart2.png" ] forState:UIControlStateNormal];
    }
    else
    {
        [  _favouriteButton setImage:[UIImage imageNamed:@"heart.png" ] forState:UIControlStateNormal];
    }
    questionNumberInt=questionNumberCount+1;
    questionNoTF.text=[NSString stringWithFormat:@"%d", questionNumberInt];
    NSString *questions = [NSString stringWithFormat:@"%d, %@", questionNumberInt, _question];
    questiontextlbl.text=questions;
    tableSelected=0;
    answerButton.hidden=TRUE;
    answerIndicatorLabel.hidden=TRUE;
    correctAnswerView.hidden=TRUE;
    [tableViews reloadData];
}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer{
    [self nextAction];

}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer{
    [self previousAction];
}

#pragma mark - Table View
-(UITableView *)makeTableView
{
    
    CGRect tableFrame = CGRectMake(0, 0,screenWidth-20, 200);
    UITableView *tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    tableView.rowHeight = 50;
    tableView.sectionFooterHeight = 22;
    tableView.sectionHeaderHeight = 22;
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.userInteractionEnabled = YES;
    tableView.bounces = YES;
    tableView.layer.cornerRadius=5;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    return tableView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"techQuizTable";
    CGRect Label1Frame = CGRectMake(40,17,screenWidth-20,18);
    UILabel *lblTemp;
    UIImageView *imgView;
    lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

    [lblTemp setFont:[UIFont fontWithName:@"Helvetica Neue" size:18]];
    lblTemp.tag = 1;
    lblTemp.backgroundColor=[UIColor clearColor];
    lblTemp.numberOfLines=0;
    lblTemp.text=[optionsAry objectAtIndex:indexPath.row];
    [cell.contentView addSubview:lblTemp];
    
    cell.imageView .frame= CGRectMake(17,19,15,15);
    if(tableSelected==0){
        [cell.imageView setImage:[UIImage imageNamed:@"checkout.png"]];
    }
    else{
        if(indexPath.row==selectedIndexPath){
            [cell.imageView setImage:[UIImage imageNamed:@"checkin.png"]];}
        else{[cell.imageView setImage:[UIImage imageNamed:@"checkout.png"]];
        }
    }
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [cell.contentView addSubview:imgView];
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section{
    return [optionsAry count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    tableSelected=1;
    selectedIndexPath=indexPath.row;
    answerIndicatorLabel.hidden = false;
    NSString *selectedAnswer = [optionsAry objectAtIndex:selectedIndexPath];
    answerIndicatorLabel.textAlignment = NSTextAlignmentCenter;
    if ([selectedAnswer isEqualToString:_correctAnswer]){
        correctAnswerView.hidden=TRUE;
        [homeScrollView setContentOffset:CGPointZero animated:YES];
        answerIndicatorLabel.text = @"Correct Answer";
        answerIndicatorLabel.backgroundColor = [UIColor greenColor];
        answerIndicatorLabel.hidden = FALSE;
        correctAnswerView.hidden = TRUE;
    }else
    {
        correctAnswerView.hidden=false;
        CGPoint bottomOffset =CGPointMake(0,homeScrollView .contentSize.height - homeScrollView.bounds.size.height-50);
        [homeScrollView setContentOffset:bottomOffset animated:YES];
        NSString * correctAnswerIndex =@"Correct Answer for the above is ";
        answertext = [NSString stringWithFormat:@"%@, %@", correctAnswerIndex, _correctAnswer];
        answertextlbl.text=answertext;
        answerIndicatorLabel.text = @"Incorrect Answer";
        answerIndicatorLabel.backgroundColor = [UIColor redColor];
        
    }
    [tableView reloadData];

}

#pragma mark - Delegate method for dropdown
-(void)cellClicked:(NSString *)contentLabel {
    
    NSLog(@"content %@",contentLabel);
    strSelectedCategories= contentLabel;
    questionNumberCount=0;
    questionNumberInt=questionNumberCount;
    [self fetchUsingCoreData:0];
    [self displaySelectedCategories:questionNumberCount];
    if ([questionCategorySelectArray count]>0) {
        
        questionNoTF.text=[NSString stringWithFormat:@"%d", questionNumberInt+1];
        totalQuestionNolbl.text=[NSString stringWithFormat:@"/ %lu",(unsigned long)[questionCategorySelectArray count]];
        NSString *questions = [NSString stringWithFormat:@"%d, %@", questionNumberInt+1, _question];
        questiontextlbl.text=questions;
        [tableViews reloadData];
    }
    else{
        [homeScrollView makeToast:@"There is no question under specified category"
         ];
    }
    
}


#pragma mark - Core Data support utility
-(NSManagedObjectContext *)managedObjectContext {
    
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication ] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
        
    }
    
    return context;
}

#pragma mark

- (void) populateArray {
    questionNoArray = [@[@"1",@"2",@"3",@"4",@"5"] mutableCopy];
    questionArray = [@[@ "Question1 ?",@"Question2 ?",@"Question3 ?",@"Question4 ?",@"Question5 ?"] mutableCopy];
    option1Array = [@[@ "Option1a ?",@"Option1b ?",@"Option1c ?",@"Option1d ?",@"Option1e ?"]
                    mutableCopy];
    option2Array = [@[@ "Option2a ?",@"Option2b ?",@"Option2c ?",@"Option2d ?",@"Option2e ?"] mutableCopy];
    option3Array = [@[@ "Option3a ?",@"Option3b ?",@"Option3c ?",@"Option3d ?",@"Option3e ?"] mutableCopy];
    option4Array = [@[@ "Option4a ?",@"Option4b ?",@"Option4c ?",@"Option4d ?",@"Option4e ?"] mutableCopy];
    correctAnswerArray = [@[@ "Option2a ?",@"Option4b ?",@"Option3c ?",@"Option1d ?",@"Option2e ?"] mutableCopy];
    questionCategoryArray = [@[@ "Objective C",@"C",@"Swift",@".NET",@"Android",@"All"] mutableCopy];
    correspondingCategoryArray=[@[@ "Objective C",@"C",@"C",@"C",@"Objective C"] mutableCopy];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuestionsKit" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSInteger count = [context countForFetchRequest:request error:&error];
  
    if (count==0) {
        
        for (int i=0; i<questionArray.count; i++) {
            NSManagedObject * newQuestionKit = [NSEntityDescription insertNewObjectForEntityForName:@"QuestionsKit" inManagedObjectContext:context];
            [newQuestionKit setValue:[questionNoArray objectAtIndex:i] forKey:@"questionNo"];
            [newQuestionKit setValue:[questionArray objectAtIndex:i] forKey:@"question"];
            [newQuestionKit setValue:[option1Array objectAtIndex:i] forKey:@"option1"];
            [newQuestionKit setValue:[option2Array objectAtIndex:i] forKey:@"option2"];
            [newQuestionKit setValue:[option3Array objectAtIndex:i] forKey:@"option3"];
            [newQuestionKit setValue:[option4Array objectAtIndex:i] forKey:@"option4"];
            [newQuestionKit setValue:[correctAnswerArray objectAtIndex:i] forKey:@"correctAnswer"];
            [newQuestionKit setValue:[questionCategoryArray objectAtIndex:i] forKey:@"questionCategory"];
            [newQuestionKit setValue:[correspondingCategoryArray objectAtIndex:i] forKey:@"correspondingCategory"];
            [newQuestionKit setValue:@"false" forKey:@"favouriteState"];
            
        }
    }
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
}

- (void) fetchUsingCoreData:(NSInteger) questionNumber
{
    NSLog(@"Fetch using HM core data entered");
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuestionsKit"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        // Handle the error.
        NSLog(@"Fetched objects = nil");
    }
    else
    {
        if([strSelectedCategories isEqualToString:@"Intial"]){
            flagDropDownSelected=0;
        _questionNo = [[fetchedObjects objectAtIndex:questionNumber] valueForKey:@"questionNo"];
        _question = [[fetchedObjects objectAtIndex:questionNumber] valueForKey:@"question"];
        _option1 = [[fetchedObjects objectAtIndex:questionNumber] valueForKey:@"option1"];
        _option2 = [[fetchedObjects objectAtIndex:questionNumber] valueForKey:@"option2"];
        _option3 = [[fetchedObjects objectAtIndex:questionNumber] valueForKey:@"option3"];
        _option4 = [[fetchedObjects objectAtIndex:questionNumber] valueForKey:@"option4"];
        _correctAnswer = [[fetchedObjects objectAtIndex:questionNumber] valueForKey:@"correctAnswer"];
        _favouriteState = [[fetchedObjects objectAtIndex:questionNumber] valueForKey:@"favouriteState"];
         _questionCategory =[[fetchedObjects objectAtIndex:questionNumber] valueForKey:@"questionCategory"];
        _corresSelectCategoryStr=[[fetchedObjects objectAtIndex:questionNumber] valueForKey:@"correspondingCategory"];
        if (optionsAry.count >0){
            [optionsAry removeAllObjects];
        }
        optionsAry=[@[_option1,_option2,_option3,_option4]mutableCopy];
        }
        else {
            if (questionCategorySelectArray.count >0){
                [questionCategorySelectArray removeAllObjects];
                 [option1SelectArray removeAllObjects];
                 [option2SelectArray removeAllObjects];
                 [option3SelectArray removeAllObjects];
                 [option4SelectArray removeAllObjects];
                 [favoriteStateSelectArray removeAllObjects];
                [correctAnswerSelectArray removeAllObjects];
            }
            int j=0;
            for (int i= 0; i<fetchedObjects.count; i++) {
            if([strSelectedCategories isEqualToString:@"All"]){
                
                NSLog(@"Not all");
                flagDropDownSelected=1;
                questionCategorySelectArray[j] = [[fetchedObjects objectAtIndex:i] valueForKey:@"question"];
                option1SelectArray[j] = [[fetchedObjects objectAtIndex:i] valueForKey:@"option1"];
                option2SelectArray[j] = [[fetchedObjects objectAtIndex:i] valueForKey:@"option2"];
                option3SelectArray[j] = [[fetchedObjects objectAtIndex:i] valueForKey:@"option3"];
                option4SelectArray[j]= [[fetchedObjects objectAtIndex:i] valueForKey:@"option4"];
                favoriteStateSelectArray[j]  = [[fetchedObjects objectAtIndex:i] valueForKey:@"favouriteState"];
                correctAnswerSelectArray[j] = [[fetchedObjects objectAtIndex:i] valueForKey:@"correctAnswer"];
                j=j+1;
                
            }
            else{
                _corresSelectCategoryStr = [[fetchedObjects objectAtIndex:i]
                                            valueForKey:@"correspondingCategory"];
                    if ([_corresSelectCategoryStr isEqualToString:strSelectedCategories]) {
                    flagDropDownSelected=1;
                    questionCategorySelectArray[j] = [[fetchedObjects objectAtIndex:i] valueForKey:@"question"];
                    option1SelectArray[j] = [[fetchedObjects objectAtIndex:i] valueForKey:@"option1"];
                    option2SelectArray[j] = [[fetchedObjects objectAtIndex:i] valueForKey:@"option2"];
                    option3SelectArray[j] = [[fetchedObjects objectAtIndex:i] valueForKey:@"option3"];
                    option4SelectArray[j]= [[fetchedObjects objectAtIndex:i] valueForKey:@"option4"];
                    favoriteStateSelectArray[j]  = [[fetchedObjects objectAtIndex:i] valueForKey:@"favouriteState"];
                    correctAnswerSelectArray[j] = [[fetchedObjects objectAtIndex:i] valueForKey:@"correctAnswer"];
                    j=j+1;
                }
            }
        }
    }
}
   
}


-(void) displaySelectedCategories:(NSInteger)questionNo {

    NSLog(@"question %@",favoriteStateSelectArray);
    if ([questionCategorySelectArray count]>0) {
    _question = [questionCategorySelectArray objectAtIndex:questionNo] ;
    _option1 = [option1SelectArray objectAtIndex:questionNo] ;
    _option2 = [option2SelectArray objectAtIndex:questionNo];
    _option3 = [option3SelectArray objectAtIndex:questionNo] ;
    _option4 = [option4SelectArray objectAtIndex:questionNo];
    _correctAnswer = [correctAnswerSelectArray objectAtIndex:questionNo] ;
    _favouriteState = [favoriteStateSelectArray objectAtIndex:questionNo] ;

    if (optionsAry.count >0)
    {
        [optionsAry removeAllObjects];
    }
    optionsAry=[@[_option1,_option2,_option3,_option4]mutableCopy];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}



@end
