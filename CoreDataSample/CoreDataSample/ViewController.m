//
//  ViewController.m
//  CoreDataSample
//
//  Created by Preejith Augustine on 08/05/16.
//  Copyright © 2016 Preejith Augustine. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
   UICollectionView *deviceCollectionView;
   UICollectionViewFlowLayout *deviceCollectionViewLayout;
    NSArray *deviceNameArray;
    NSArray *deviceImageArray;
    
    NSString *favoritedState;
    NSString *deviceName;
    NSString *deviceImageName;
    
    UILabel *deviceNamelbl;
    UIButton *favoriteBtn;
    UIButton *editBtn;
    
    int pages;

}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.view.backgroundColor = [UIColor grayColor];

    [self intialData];
    deviceCollectionViewLayout=[[UICollectionViewFlowLayout alloc] init];
    deviceCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height*0.475) collectionViewLayout:deviceCollectionViewLayout];
    [deviceCollectionViewLayout setMinimumLineSpacing:0];
    [deviceCollectionViewLayout setMinimumInteritemSpacing:1];
    [deviceCollectionViewLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [deviceCollectionViewLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [deviceCollectionView setDataSource:self];
    [deviceCollectionView setDelegate:self];
    [deviceCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [deviceCollectionView setBackgroundColor:[UIColor darkGrayColor]];
    deviceCollectionView.showsHorizontalScrollIndicator=NO;
    [deviceCollectionView setPagingEnabled:YES];
    [deviceCollectionView setBounces:NO];
    
    [self.view addSubview:deviceCollectionView];
    
    deviceNamelbl= [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-75, deviceCollectionView.frame.size.height+40, 180, 40)];
    deviceNamelbl.textColor =[UIColor blackColor];
    deviceNamelbl.backgroundColor=[UIColor whiteColor];
    deviceNamelbl.font = [UIFont systemFontOfSize:25];
    deviceNamelbl.textAlignment=NSTextAlignmentCenter;
    deviceNamelbl.text= deviceName;
    [self.view addSubview:deviceNamelbl];
    
     editBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width -60,deviceCollectionView.frame.size.height-40,50,30)];
    [editBtn setTitle:@"Edit" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    editBtn.backgroundColor=[UIColor redColor];
    [editBtn addTarget:self action:@selector(editAndSave) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: editBtn];
    
     favoriteBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width -40,16,30,30)];
    if ([favoritedState isEqualToString:@"true"]) {
            [favoriteBtn setImage:[UIImage imageNamed:@"favorite.jpg" ] forState:UIControlStateNormal];
    }
    else{
        [favoriteBtn setImage:[UIImage imageNamed:@"favoriteEmpty.png" ] forState:UIControlStateNormal];
    }
    [favoriteBtn addTarget:self action:@selector(favouriteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:favoriteBtn];
    
    
}




-(void) intialData{
    deviceImageArray=[NSArray arrayWithObjects:@"iPhone.jpg",@"Samsung.jpg",@"Htc.jpg",@"Micromax.jpg",@"LG.jpg", nil];
    deviceNameArray=[NSArray arrayWithObjects:@"iPhone",@"Samsung",@"HTC",@"Micromax",@"Lg",nil];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Devices" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSInteger count = [context countForFetchRequest:request error:&error];
    NSLog(@"count =%ld",(long)count);
    if (count==0) {
        for (int i=0; i<deviceImageArray.count; i++) {
            NSManagedObject * newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Devices" inManagedObjectContext:context];
            [newDevice setValue:[deviceImageArray objectAtIndex:i] forKey:@"deviceImage"];
            [newDevice setValue:[deviceNameArray objectAtIndex:i] forKey:@"deviceName"];
            [newDevice setValue:@"false" forKey:@"deviceFavorite"];
        }
        
    }
    else{
        NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
        if (fetchedObjects == nil) {
            // Handle the error.
        
        }
        else
        {
            favoritedState = [[fetchedObjects objectAtIndex:0] valueForKey:@"deviceFavorite"];
            deviceName = [[fetchedObjects objectAtIndex:0] valueForKey:@"deviceName"];
            deviceImageName= [[fetchedObjects objectAtIndex:0] valueForKey:@"deviceImage"];
            NSLog(@"deviceImageName %@",deviceImageName);
        }

    }

    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
}


- (void)favouriteAction {
   
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Devices" inManagedObjectContext:context]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceName = %@",deviceName];
    NSLog(@"deviceName %@",deviceName);
    
    if ([favoritedState isEqualToString: @"false"])
    {

        [favoriteBtn setImage:[UIImage imageNamed:@"favorite.jpg" ] forState:UIControlStateNormal];
        
        favoritedState = @"true";
    
        [request setPredicate:predicate];
        
        NSError  *error = nil;
        NSArray *results = [context executeFetchRequest:request error:&error];
        
        NSManagedObject *favoritsGrabbed = [results objectAtIndex:0];
        [favoritsGrabbed setValue:@"true" forKey:@"deviceFavorite"];
        
        if (![context save:&error]) {
            NSLog(@"Cant Save! %@ %@", error, [error localizedDescription]);
        }
        
    }
    else if ([favoritedState isEqualToString:@"true"]){
     
        [favoriteBtn setImage:[UIImage imageNamed:@"favoriteEmpty.png" ] forState:UIControlStateNormal];
        favoritedState = @"false";
        [request setPredicate:predicate];
        
        NSError  *error = nil;
        NSArray *results = [context executeFetchRequest:request error:&error];
        
        NSManagedObject *favoritsGrabbed = [results objectAtIndex:0];
        [favoritsGrabbed setValue:@"false" forKey:@"deviceFavorite"];
        
        if (![context save:&error]) {
            NSLog(@"Cant Save! %@ %@", error, [error localizedDescription]);
        }
  
    }

}


-(void)editAndSave{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Edit & Save"
                                                    message:@"Edit Device Name."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                          
                                          otherButtonTitles:nil];
    alert.alertViewStyle =UIAlertViewStylePlainTextInput;
    UITextField *alertTextField =[alert textFieldAtIndex:0];
    NSLog(@"test %@",deviceNamelbl.text);
    alertTextField.text = deviceNamelbl.text;
    alert.tag =1;
    [alert addButtonWithTitle:@"Save"];
    
    
    [alert show];
}



- (void) alertView: (UIAlertView *) alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            UITextField *textField = [alertView textFieldAtIndex:0];
            //NSLog(@"File to save is  %@",textField.text);
            if ([textField.text isEqualToString: @""])
            {
                NSLog(@"Error : Cant save blank record");
            }
            else {
                NSManagedObjectContext *context = [self managedObjectContext];
                NSFetchRequest *request = [[NSFetchRequest alloc] init];
                [request setEntity:[NSEntityDescription entityForName:@"Devices" inManagedObjectContext:context]];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceName = %@", deviceNamelbl.text];
                
                [request setPredicate:predicate];
                
                NSError  *error = nil;
                NSArray *results = [context executeFetchRequest:request error:&error];
                
                NSManagedObject *brandGrabbed = [results objectAtIndex:0];
                [brandGrabbed setValue:textField.text forKey:@"deviceName"];
                 NSLog(@"test %@",textField.text);
                deviceNamelbl.text=textField.text;
                if (![context save:&error]) {
                    NSLog(@"Cant Save! %@ %@", error, [error localizedDescription]);
                }
                // fetch again to get the updated values
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Devices"
                                                          inManagedObjectContext:context];
                [fetchRequest setEntity:entity];
                
                
                NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
                if (fetchedObjects == nil) {
                    // Handle the error.
                    NSLog(@"Fetched objects = nil");
                }
                else
                {
                    favoritedState = [[fetchedObjects objectAtIndex:pages-1] valueForKey:@"deviceFavorite"];
                    deviceName = [[fetchedObjects objectAtIndex:pages-1] valueForKey:@"deviceName"];
                    deviceImageName= [[fetchedObjects objectAtIndex:pages-1] valueForKey:@"deviceImage"];
                    
                }
            }
        }
    }
    
}



- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

#pragma mark -  Collection View delegates
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return productCollectionArray.count;  //commented for returning only one image
    return [deviceImageArray count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(deviceCollectionView.frame.size.width, deviceCollectionView.frame.size.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UIImageView *productImageView;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    float       cellWidth;
    float       cellHeight;
    cellWidth   = cell.frame.size.width;
    cellHeight  = cell.frame.size.height;
    productImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,cellWidth,cellHeight)];
    productImageView.image =[UIImage imageNamed:deviceImageName];
    deviceNamelbl.text= deviceName;
    productImageView.contentMode = UIViewContentModeScaleAspectFill;
    [cell addSubview:productImageView];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cells = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    for (UIView *views in [cells subviews]) {
        [views removeFromSuperview];
    }
}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == deviceCollectionView) {
        pages = floor(deviceCollectionView.contentSize.width /
                          deviceCollectionView.frame.size.width);
        
        pages = deviceCollectionView.contentOffset.x / deviceCollectionView.frame.size.width +1;
      
        
        
        NSManagedObjectContext *context = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Devices"
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        NSError *error;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            // Handle the error.
            NSLog(@"Fetched objects = nil");
        }
        else{
            
            favoritedState = [[fetchedObjects objectAtIndex:pages-1] valueForKey:@"deviceFavorite"];
            deviceName = [[fetchedObjects objectAtIndex:pages-1] valueForKey:@"deviceName"];
            deviceImageName= [[fetchedObjects objectAtIndex:pages-1] valueForKey:@"deviceImage"];
            if ([favoritedState isEqualToString:@"true"]) {
                [favoriteBtn setImage:[UIImage imageNamed:@"favorite.jpg" ] forState:UIControlStateNormal];
                
            }
            else{
            [favoriteBtn setImage:[UIImage imageNamed:@"favoriteEmpty.png" ] forState:UIControlStateNormal];
                
            }

            
            
        }
        
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
