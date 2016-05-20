//
//  FavouriteViewController.m
//  TechQuiz
//
//  Created by Pramod Kumar G on 11/05/16.
//  Copyright © 2016 Preejith Augustine. All rights reserved.
//

#import "FavouriteViewController.h"
#import "UIView+Toast.h"


@interface FavouriteViewController (){
    float screenWidth;
    float screenHeight;
    float tabBarHeight;
    float statusBarHeight;
    float navBarHeight;
    
    int tableSelected;
    int selectedIndexPath;
    
    UIView *baseView;
    UIView *topMenuView;
    UIView *correctAnswerView;
    UIView *selectCategoryTF;
    
    UITextField *questionNoTF;
    UILabel *totalQuestionNolbl;
    UILabel *questionNolbl;
    UILabel *questiontextlbl;
    UILabel *answer;
    UILabel *answerIndicatorLabel;
    UILabel *answertextlbl;
    
    UIButton *previousbutton;
    UIButton *kbHideButton;
    
  
    BOOL listFlag;
    
    
    UIScrollView *homeScrollView;
    NSArray *tableData;
    UITableView *tableViews;
    
    NSString *answertext;
    NSMutableArray *optionsAry;
    
    NSInteger  questionNumberCount;
    NSInteger  questionNumberInt;
    
}

@end

@implementation FavouriteViewController
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
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
    [self fetchFromCoreData];
     [self loadIntialView];


}

-(void) viewWillAppear:(BOOL)animated{
   [self fetchFromCoreData];
    totalQuestionNolbl.text=[NSString stringWithFormat:@"/ %lu",(unsigned long)[_questionArray count]];

  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}



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
    
    questionNumberCount=0;
    tableSelected=0;
    [self displayFavoriteData:questionNumberCount];
    
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
    
    //NSLog(@"the width of yourLabel is %f", leftLabelWidth);
    
    totalQuestionNolbl  = [[UILabel alloc] initWithFrame:CGRectMake(previousbutton.frame.origin.x+35+leftLabelWidth,10,60,30)];
    totalQuestionNolbl.textColor = [UIColor blackColor];
    [totalQuestionNolbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:20]];
    totalQuestionNolbl.text=[NSString stringWithFormat:@"/ %lu",(unsigned long)[_questionArray count]];
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
    
     questionNumberInt=questionNumberCount;
    NSString *questions = [NSString stringWithFormat:@"%d, %@", questionNumberInt+1,_question];
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
    // NSLog(@"number of lines %ld",(long)questiontextlbl.numberOfLines);
    questiontextlbl.frame=CGRectMake(10,10,screenWidth-20,20*(expectedSize.height/20)+20);
    questiontextlbl.textAlignment=NSTextAlignmentLeft;
    [questiontextlbl setTextColor:[UIColor blackColor]];
    [homeScrollView addSubview:questiontextlbl];
    
    
    UIView * answerOptionsView=[[UIView alloc]initWithFrame:CGRectMake(10,questiontextlbl.frame.size.height+20,screenWidth-20 ,200)];
  
    [homeScrollView addSubview:answerOptionsView];
    tableViews = [self makeTableView];
    [tableViews registerClass:[UITableViewCell class] forCellReuseIdentifier:@"techQuizTable"];
    [answerOptionsView addSubview:tableViews];

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
    
 
    
    selectCategoryTF=[[UIView alloc]initWithFrame:CGRectMake(20,screenHeight*0.18+3,screenWidth-40, screenHeight*0.09)];
   
    selectCategoryTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
    [baseView addSubview: selectCategoryTF];
 
}


-(void)showList{
}

-(void) previousAction{
    NSLog(@"countofQnext %d",questionNumberCount);
    if (questionNumberCount>0) {
        questionNumberCount=   questionNumberCount-1;
        [self nextquestions];
    }
    
    
}
-(void) nextAction{
     NSLog(@"countofQnext %d",questionNumberCount);
    if (questionNumberCount <[_questionArray count]-1) {
        questionNumberCount=   questionNumberCount+1;
        [self nextquestions];
    }
}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"Right side");
    NSLog(@"countofQnext %d",questionNumberCount);
    if (questionNumberCount <[_questionArray count]-1) {
        questionNumberCount=   questionNumberCount+1;
        [self nextquestions];
    }
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{   NSLog(@"Left side");
    NSLog(@"countofQnext %d",questionNumberCount);
    if (questionNumberCount>0) {
        questionNumberCount=   questionNumberCount-1;
        [self nextquestions];
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


-(void)nextquestions{
    
    [self displayFavoriteData:questionNumberCount];
    NSLog(@"Favourite state in next questions = %@",_favouriteState);
    questionNumberInt=questionNumberCount+1;
    questionNoTF.text=[NSString stringWithFormat:@"%d", questionNumberInt];
    NSString *questions = [NSString stringWithFormat:@"%d, %@", questionNumberInt, _question];
    questiontextlbl.text=questions;
    tableSelected=0;
    answerIndicatorLabel.hidden=TRUE;
    correctAnswerView.hidden=TRUE;
    [tableViews reloadData];
}


#pragma mark -  Text Field delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"name"];
//   // textField.text = @"";
//}
//
//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//////    if ([textField.text isEqualToString:@""])
////        textField.text  = [[NSUserDefaults standardUserDefaults]
////                           stringForKey:@"name"];
////    NSInteger intQuestionNo =[questionNoTF.text integerValue];
////    NSString *tempQuestionNumber=questionNoTF.text;
////    NSLog(@"tempQuestion %@",tempQuestionNumber);
////    if (intQuestionNo==0) {
////        //questionNoTF.text  = [[NSUserDefaults standardUserDefaults]
////                         //  stringForKey:@"name"];
//        NSLog(@"Testfff");
//      //  [homeScrollView makeToast:@"Enter a valid question Number"
//        // ];
//    }
//    else if(intQuestionNo >[_questionArray count]){
//        //questionNoTF.text  = [[NSUserDefaults standardUserDefaults]
//                           //stringForKey:@"name"];
//  NSLog(@"Testfff");
//        //[homeScrollView makeToast:@"Enter a valid question Number"
//         //];
//    }
//    
//    
//    NSLog(@"test %@",questionNoTF.text);
//    return YES;
//}

- (void)textFieldDidChange {
    
    NSString *tempQuestionNumber=questionNoTF.text;
    NSLog(@"tempQuestion %@",tempQuestionNumber);
    if (![questionNoTF.text isEqualToString:@""]) {
        NSAttributedString *attributedLeftText = [[NSAttributedString alloc] initWithString:questionNoTF.text attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSUnderlineColorAttributeName:[UIColor clearColor]}];
        questionNoTF.attributedText = [attributedLeftText copy];
        float leftLabelWidth = [questionNoTF.text boundingRectWithSize:questionNoTF.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:questionNoTF.font } context:nil] .size.width;
        totalQuestionNolbl.frame=CGRectMake(previousbutton.frame.origin.x+35+leftLabelWidth,10,60,30);
      //  questionNoTF.text=@"1";
        NSLog(@"question number %d",questionNumberCount);
        NSLog(@"question number %d",questionNumberInt);

        
    }
    
}


- (void)keyboardWillShow:(NSNotification *)notification {
    kbHideButton.hidden=false;
}

- (void)dismissKeyboard {
    [questionNoTF resignFirstResponder];
    [homeScrollView setContentOffset:CGPointZero animated:YES];
    kbHideButton.hidden=true;
    
    NSInteger intQuestionNo =[questionNoTF.text integerValue];
    NSString *tempQuestionNumber=questionNoTF.text;

    if (intQuestionNo==0) {
         questionNoTF.text=[NSString stringWithFormat:@"%d", questionNumberInt];
        [homeScrollView makeToast:@"Enter a valid question Number"
         ];
    }
    else if(intQuestionNo >[_questionArray count]){
         questionNoTF.text=[NSString stringWithFormat:@"%d", questionNumberInt];
        [homeScrollView makeToast:@"Enter a valid question Number"
         ];
    }
    else{
        questionNumberCount=intQuestionNo-1;
        [self displayFavoriteData:questionNumberCount];
        questionNumberInt=questionNumberCount+1;
        questionNoTF.text=[NSString stringWithFormat:@"%d", questionNumberInt];
        NSString *questions = [NSString stringWithFormat:@"%d, %@", questionNumberInt, _question];
        questiontextlbl.text=questions;
        tableSelected=0;
        answerIndicatorLabel.hidden=TRUE;
        [tableViews reloadData];
    }
    
    
}


#pragma mark -Table View
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
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
        
    }
    else
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



- (void) fetchFromCoreData
{
        NSManagedObjectContext *context = [self managedObjectContext];
    
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuestionsKit" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
  
       NSError *error;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
                // Handle the error.
                NSLog(@"Fetched objects = nil");
            }
        else
            {
                   _favouriteStateArray=[[NSMutableArray alloc]init];
                    _questionArray =[[NSMutableArray alloc]init];
                    _option1Array =[[NSMutableArray alloc]init];
                    _option2Array =[[NSMutableArray alloc]init];
                    _option3Array =[[NSMutableArray alloc]init];
                    _option4Array =[[NSMutableArray alloc]init];
                    _correctAnswerArray =[[NSMutableArray alloc]init];
            
                    int j=0;
                    for (int i=0;i< fetchedObjects.count ; i++)
                        {
                                _favouriteState = [[fetchedObjects objectAtIndex:i] valueForKey:@"favouriteState"];
                    
                                if ([_favouriteState isEqualToString:@"true"]) {
                                    
                                        //NSLog(@"_favourite state is true hence in if loop");
                                        _questionArray[j] = [[fetchedObjects objectAtIndex:i] valueForKey:@"question"];
                                        _option1Array[j] = [[fetchedObjects objectAtIndex:i] valueForKey:@"option1"];
                                        _option2Array[j] = [[fetchedObjects objectAtIndex:i] valueForKey:@"option2"];
                                        _option3Array[j] = [[fetchedObjects objectAtIndex:i] valueForKey:@"option3"];
                                        _option4Array[j] = [[fetchedObjects objectAtIndex:i] valueForKey:@"option4"];
                                        _correctAnswerArray[j] = [[fetchedObjects objectAtIndex:i]
                                                                                                           valueForKey:@"correctAnswer"];
                                    
                        
                                        _questionCategoryArray[j] = [[fetchedObjects objectAtIndex:i]
                                                                                                                   valueForKey:@"questionCategory"];
                                    
                                        j=j+1;
                                    }
                            
                            }
                for (int i= 0; i<fetchedObjects.count; i++) {
                    _questionCategory = [[fetchedObjects objectAtIndex:i]
                                                 valueForKey:@"questionCategory"];
                    
                    
                    if ([_questionCategory isEqualToString:@"C"]) {
                        
                       _question = [[fetchedObjects objectAtIndex:i] valueForKey:@"question"];
                        NSLog(@"The question for C language is %@",_question);
                    }
                    
                }
            }
}
-(void) displayFavoriteData:(NSInteger)questionNumber{
    
    
    
    _option1=[_option1Array objectAtIndex:questionNumber];
    _option2=[_option2Array objectAtIndex:questionNumber];
    _option3=[_option3Array objectAtIndex:questionNumber];
    _option4=[_option4Array objectAtIndex:questionNumber];
    _question=[_questionArray objectAtIndex:questionNumber];
    _correctAnswer =[ _correctAnswerArray objectAtIndex:questionNumber];
    NSLog(@"options %@",_option1); NSLog(@"options %@",_option2);
    if (optionsAry.count >0)
    {
        [optionsAry removeAllObjects];
    }
    optionsAry=[@[_option1,_option2,_option3,_option4]mutableCopy];
    
    NSLog(@"options %@",optionsAry);
    
}




@end
