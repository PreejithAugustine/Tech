//
//  HomeViewController.m
//  TechQuiz
//
//  Created by Pramod Kumar G on 11/05/16.
//  Copyright © 2016 Preejith Augustine. All rights reserved.
//

#import "HomeViewController.h"

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
    
    UIButton *previousbutton;
    UIButton *kbHideButton;
    UIButton * answerButton;
    
    DropdownList *list;
    BOOL listFlag;
    
    UIScrollView*homeScrollView;
    
    NSArray *tableData;
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
    
    NSInteger  questionNumberCount;
    NSMutableArray *optionsAry;
    
    
    
}

@end

@implementation HomeViewController

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

- (void)viewDidLoad {
    [super viewDidLoad];
    [self populateArray];
     
    [self.navigationItem setTitle:@"Thech -Quiz"];
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

    UIButton *favoriteBtn =[[UIButton alloc]initWithFrame:CGRectMake(screenWidth-90,10, 30, 30)];
    [favoriteBtn setImage:[UIImage imageNamed:@"heart.png"]forState:UIControlStateNormal];
    [favoriteBtn addTarget:self action:@selector(favoriteAction) forControlEvents:UIControlEventTouchUpInside];
    [topMenuView addSubview:favoriteBtn];
    
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
    
    NSLog(@"the width of yourLabel is %f", leftLabelWidth);
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
    NSString * questionNumber =_questionNo;
    NSString * questiontext = _question;
   
    NSString *questions = [NSString stringWithFormat:@"%@, %@", _questionNo, _question];
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
    // questiontextlbl.backgroundColor=[UIColor whiteColor];
    // questiontextlbl.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
    [questiontextlbl setTextColor:[UIColor blackColor]];
    [homeScrollView addSubview:questiontextlbl];
    
    UIView * answerOptionsView=[[UIView alloc]initWithFrame:CGRectMake(10,questiontextlbl.frame.size.height+20,screenWidth-20 ,200)];
    // answerOptionsView.backgroundColor=[UIColor greenColor];
    [homeScrollView addSubview:answerOptionsView];
    
    tableViews = [self makeTableView];
    [tableViews registerClass:[UITableViewCell class] forCellReuseIdentifier:@"newFriendCell"];
    [answerOptionsView addSubview:tableViews];
    
    
    selectCategoryTF=[[UIView alloc]initWithFrame:CGRectMake(20,screenHeight*0.18+3,screenWidth-40, screenHeight*0.09)];
    selectCategoryTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
    [baseView addSubview: selectCategoryTF];
    
//    answerButton =[[UIButton alloc] initWithFrame:CGRectMake(10,answerOptionsView.frame.origin.y+answerOptionsView.frame.size.height+10, 150,40)];
//    answerButton.backgroundColor=[UIColor redColor];
//    answerButton.hidden=TRUE;
//    answerButton.layer.cornerRadius=10;
//    answerButton.clipsToBounds=YES;
//    [answerButton setBackgroundColor:[UIColor whiteColor]];
//    [answerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [answerButton addTarget:self action:@selector(answerAction) forControlEvents:UIControlEventTouchUpInside];
//    [answerButton setTitle:@"Correct answer"forState:UIControlStateNormal];
//    [homeScrollView addSubview:answerButton];
    
    
    
    
//    correctAnswerView=[[UIView alloc]initWithFrame:CGRectMake(10, answerButton.frame.origin.y+answerButton.frame.size.height+10, screenWidth-20, 80)];
//    correctAnswerView.backgroundColor=[UIColor whiteColor];
//    correctAnswerView.layer.cornerRadius=10;
//    correctAnswerView.hidden=TRUE;
//    correctAnswerView.clipsToBounds=YES;
//    [homeScrollView addSubview:correctAnswerView];
    
    answerIndicatorLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,answerOptionsView.frame.origin.y+answerOptionsView.frame.size.height+10, 150,40)];
    answerIndicatorLabel.backgroundColor = [UIColor redColor];
    answerIndicatorLabel.hidden = TRUE;
    answerIndicatorLabel.layer.cornerRadius = 10;
    answerIndicatorLabel.clipsToBounds = YES;
    [answerIndicatorLabel setBackgroundColor:[UIColor whiteColor]];
    [homeScrollView addSubview:answerIndicatorLabel];
    
    NSString * correctAnswerIndex =@"Correct Answer for the above is ";
    NSString * correctAnswerStr =@"Dennis Ritchie";
    NSString *answertext = [NSString stringWithFormat:@"%@, %@", correctAnswerIndex, correctAnswerStr];
    
    UILabel *answertextlbl=[[UILabel alloc]initWithFrame:CGRectMake(10,-10,screenWidth-20,80)];
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




- (void)cellClicked:(NSString *)contentLabel {
    
}

- (void)showList {
    [self dismissKeyboard];
    [UIView makeTableView];
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    kbHideButton.hidden=false;
}

- (void)dismissKeyboard {
    [questionNoTF resignFirstResponder];
    [homeScrollView setContentOffset:CGPointZero animated:YES];
    kbHideButton.hidden=true;
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

#pragma  mark


-(void)favoriteAction{
}

-(void) howList{}
-(void) previousAction{
   
   questionNumberCount=   questionNumberCount-1;
   NSLog(@"countofQnext %d",questionNumberCount);
   [self nextquestions];

}
-(void) nextAction{
    
     questionNumberCount=   questionNumberCount+1;
     NSLog(@"countofQnext %d",questionNumberCount);
    [self nextquestions];
   
}


-(void)nextquestions{

    [self fetchUsingCoreData:questionNumberCount];
    NSString *questions = [NSString stringWithFormat:@"%@, %@", _questionNo, _question];
    questiontextlbl.text=questions;
    tableSelected=0;
    answerButton.hidden=TRUE;
    NSLog(@"options %@",optionsAry);
    [tableViews reloadData];
}

-(void) answerAction{
    //[homeScrollView setContentOffset:CGPointZero animated:YES];
    CGPoint bottomOffset =CGPointMake(0,homeScrollView .contentSize.height - homeScrollView.bounds.size.height);
    [homeScrollView setContentOffset:bottomOffset animated:YES];
    correctAnswerView.hidden=false;
    
}



-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"Left side");
    questionNumberCount=   questionNumberCount-1;
    NSLog(@"countofQnext %d",questionNumberCount);
    [self nextquestions];

}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"Right side");
    questionNumberCount=   questionNumberCount-1;
    NSLog(@"countofQnext %d",questionNumberCount);
    [self nextquestions];
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
    static NSString *CellIdentifier = @"newFriendCell";
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
  //  NSLog(@"%@ counts",[optionsAry objectAtIndex:indexPath.row]);
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
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableSelected=1;
    selectedIndexPath=indexPath.row;
   // answerButton.hidden=false;
    answerIndicatorLabel.hidden=false;
    NSString *correctAnswer=[optionsAry objectAtIndex:indexPath.row];
    NSLog(@"selected correct %@",correctAnswer);
    [tableView reloadData];
    
    
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

- (void) populateArray {
    questionNoArray = [@[@"1",@"2",@"3",@"4",@"5"] mutableCopy];
    questionArray = [@[@ "Question1 ?",@"Question2 ?",@"Question3 ?",@"Question4 ?",@"Question5 ?"] mutableCopy];
    option1Array = [@[@ "Option1a ?",@"Option1b ?",@"Option1c ?",@"Option1d ?",@"Option1e ?"]
                    mutableCopy];
    option2Array = [@[@ "Option2a ?",@"Option2b ?",@"Option2c ?",@"Option2d ?",@"Option2e ?"] mutableCopy];
    option3Array = [@[@ "Option3a ?",@"Option3b ?",@"Option3c ?",@"Option3d ?",@"Option3e ?"] mutableCopy];
    option4Array = [@[@ "Option4a ?",@"Option4b ?",@"Option4c ?",@"Option4d ?",@"Option4e ?"] mutableCopy];
    correctAnswerArray = [@[@ "Option2a ?",@"Option4b ?",@"Option3c ?",@"Option1d ?",@"Option2e ?"] mutableCopy];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuestionsKit" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSInteger count = [context countForFetchRequest:request error:&error];
    
    //create a new managed object and save to core data
    NSLog(@"count =%d",count);
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
            
        }
    }
    //save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
}

- (void) fetchUsingCoreData:(NSInteger) questionNumber
{
    NSLog(@"Fetch using core data entered");
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
        
        _questionNo = [[fetchedObjects objectAtIndex:questionNumber] valueForKey:@"questionNo"];
        _question = [[fetchedObjects objectAtIndex:questionNumber] valueForKey:@"question"];
        _option1 = [[fetchedObjects objectAtIndex:questionNumber] valueForKey:@"option1"];
        _option2 = [[fetchedObjects objectAtIndex:questionNumber] valueForKey:@"option2"];
        _option3 = [[fetchedObjects objectAtIndex:questionNumber] valueForKey:@"option3"];
        _option4 = [[fetchedObjects objectAtIndex:questionNumber] valueForKey:@"option4"];
        _correctAnswer=[[fetchedObjects objectAtIndex:questionNumber] valueForKey:@"correctAnswer"];
        NSLog(@"Correct %@",_correctAnswer);
    
        if (optionsAry.count >0)
        {
            [optionsAry removeAllObjects];
        }
        optionsAry=[@[_option1,_option2,_option3,_option4]mutableCopy];
        
    }
    NSLog(@"_questionNo =%@",_questionNo);
//    NSLog(@"_question =%@",_question);
//    NSLog(@"_option1 =%@",_option1);
//    NSLog(@"_option2 =%@",_option2);
//    NSLog(@"_option3 =%@",_option3);
//    NSLog(@"_option4 =%@",_option4);
    NSLog(@"Fetch using core data exited");
}


@end
