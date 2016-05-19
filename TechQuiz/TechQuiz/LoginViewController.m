//
//  LoginViewController.m
//  TechQuiz
//
//  Created by Preejith Augustine on 11/05/16.
//  Copyright © 2016 Preejith Augustine. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"

@interface LoginViewController (){
    float screenWidth;
    float screenHeight;
    UIView *loginView;
    
    UITextField *passwordTF;
    UITextField *userNameTF;
    
    UIButton *kbHideButton;
    CGFloat currentKeyboardHeight;
    float kbHeight;
    
    HomeViewController *homeViewController;
    
    
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
   // self.view.backgroundColor=[UIColor grayColor];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    
    [self createLoginUI];
    
    [self insertLoginDetais];
    
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



#pragma  mark - Custom Code

- (void) insertLoginDetais {
    //NSLog(@"Into insertLoginDetails");
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LoginDetails" inManagedObjectContext:context];
    [request setEntity:entity];
    
    
    NSError *error = nil;
    NSInteger count = [context countForFetchRequest:request error:&error];
    
    //create a new managed object and save to core data
    
    if (count==0) {
        
            NSManagedObject * aPerson = [NSEntityDescription insertNewObjectForEntityForName:@"LoginDetails" inManagedObjectContext:context];
            [aPerson setValue:@"a" forKey:@"userName"];
            [aPerson setValue:@"a" forKey:@"password"];
        
     }

    //save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
}
- (void)createLoginUI {
    screenWidth = self.view.frame.size.width;
    screenHeight = self.view.frame.size.height;
    loginView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    loginView.backgroundColor=[UIColor grayColor];
    [self.view addSubview:loginView];
    
    currentKeyboardHeight = 0.0;
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,100,100)];
    logoImageView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2-140);
    logoImageView.backgroundColor=[UIColor whiteColor];
    logoImageView.image = [UIImage imageNamed:@"quiz.jpg"];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [loginView addSubview:logoImageView];

    userNameTF=[[UITextField alloc]initWithFrame:CGRectMake(20, screenHeight-280,screenWidth-40, 40)];
    userNameTF.center = CGPointMake(self.view.frame.size.width/2-10,screenHeight-275);
    userNameTF.placeholder = @"User Name";
    [userNameTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    userNameTF.textAlignment=NSTextAlignmentCenter;
    userNameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userNameTF.font = [UIFont fontWithName:@"Helvetica Neue" size:15];
    userNameTF.delegate = self;
    userNameTF.autocorrectionType=UITextAutocorrectionTypeNo;
    userNameTF.textColor=[UIColor whiteColor];
    userNameTF.keyboardType = UIKeyboardTypeDefault;
    userNameTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
   [loginView addSubview:userNameTF];
    
    UIView *emailLine = [[UILabel alloc] initWithFrame:CGRectMake(20, screenHeight-255,screenWidth-40,1)];
    emailLine.backgroundColor=[UIColor whiteColor];
    [loginView addSubview:emailLine];
    
    passwordTF=[[UITextField alloc]initWithFrame:CGRectMake(20, screenHeight-250,screenWidth-40, 40)];
    passwordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordTF.center = CGPointMake(self.view.frame.size.width/2-10,screenHeight-230);
    passwordTF.placeholder = @"Password";
    [passwordTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    passwordTF.textColor=[UIColor whiteColor];
    passwordTF.secureTextEntry=YES;
    passwordTF.textAlignment=NSTextAlignmentCenter;
    passwordTF.font = [UIFont fontWithName:@"Helvetica Neue" size:15];
    passwordTF.delegate = self;
    
    passwordTF.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
    [loginView addSubview:passwordTF];
    
    UIView *passWordLine = [[UILabel alloc] initWithFrame:CGRectMake(20, screenHeight-210,screenWidth-40,1)];
    passWordLine.backgroundColor=[UIColor whiteColor];
    [loginView addSubview:passWordLine];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(25, screenHeight-170, screenWidth-40, 40)];
    loginButton.layer.cornerRadius=10;
    loginButton.clipsToBounds=YES;
    [loginButton setBackgroundColor:[UIColor whiteColor]];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"Log in"forState:UIControlStateNormal];
    [loginView addSubview:loginButton];
    
    kbHideButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    kbHideButton.backgroundColor = [UIColor clearColor];
    kbHideButton.hidden=true;
    [kbHideButton addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:kbHideButton];
    
    [loginView bringSubviewToFront:userNameTF];
    [loginView bringSubviewToFront:passwordTF];
    
  
}

- (void)keyboardWillShow:(NSNotification *)notification {
    kbHideButton.hidden = false;
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    kbHeight = keyboardFrameBeginRect.size.height-currentKeyboardHeight ;
    float baseHeight  = self.view.frame.size.height;
    float freeHeight = (baseHeight-keyboardFrameBeginRect.size.height);
    float heightTobeMoved = 0;
    if([passwordTF isFirstResponder]){
        CGRect frame = passwordTF.frame;
        if (freeHeight<(frame.origin.y+frame.size.height+40)) {
            heightTobeMoved=(frame.origin.y+frame.size.height+40)-freeHeight;
        }
        [UIView animateWithDuration:0.4f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             
                             loginView.frame = CGRectMake(loginView.frame.origin.x,loginView.frame.origin.y-heightTobeMoved, loginView.frame.size.width,loginView.frame.size.height );
                         }
                         completion:^(BOOL finished)
         {
             
         }];
    }
}

-(void) dismissKeyboard
{
    
    [userNameTF resignFirstResponder];
    [passwordTF resignFirstResponder];
    kbHideButton.hidden=TRUE;
    [UIView animateWithDuration:0.4f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         loginView .frame = CGRectMake(0,0, loginView.frame.size.width,  loginView.frame.size.height );
                     }
                     completion:^(BOOL finished)
     {
         
     }];
    
}


-(void) loginAction{

    [self fetchLoginDetails];
    if (userNameTF.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Tech-Quiz"
                                                        message:@"Please fill the credentials."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if (passwordTF.text.length==0)
    {  UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Tech-Quiz"
                                                       message:@"Please fill the credentials."
                                                      delegate:nil
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil];
        [alert show];
        
    }
    else if([[userNameTF.text lowercaseString] isEqualToString:_userName] && [passwordTF.text isEqualToString:_password]){
        [self navigateToHomeView];
    }    
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tech-Quiz"
                                                        message:@"Invalid User credentials."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
}

- (void) fetchLoginDetails
{
    
    //NSLog(@"fetchLoginDetails");
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LoginDetails"
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
        _userName = [[fetchedObjects objectAtIndex:0] valueForKey:@"userName"];
        _password = [[fetchedObjects objectAtIndex:0] valueForKey:@"password"];
       // NSLog(@"_userName = %@",_userName);
        //NSLog(@"_password = %@",_password);
    }
}

#pragma mark -  Text Field delegates
-(void) navigateToHomeView{

    HomeViewController *homeView = [[HomeViewController alloc] init];
    homeViewController = homeView;
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
     
    [appDelegate.tabBarController setSelectedIndex:0];
    [appDelegate.window setRootViewController:appDelegate.tabBarController];
//    UINavigationController *viewMenu = [[UINavigationController alloc] initWithRootViewController:homeView];
//      AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//     [appDelegate.window setRootViewController:viewMenu];
//      viewMenu.navigationBar.barTintColor=[UIColor darkGrayColor];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self dismissKeyboard];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)Intialtheview {
  
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
