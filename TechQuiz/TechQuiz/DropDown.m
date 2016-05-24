//
//  DropDown.m
//  TechQuiz
//
//  Created by Preejith Augustine on 18/05/16.
//  Copyright © 2016 Preejith Augustine. All rights reserved.
//

#import "DropDown.h"

@implementation DropDown
@synthesize  baseView;
@synthesize  closeButton;
@synthesize dropDownTableViews;
@synthesize arrCategories;


-(UIView *)tableView :(NSArray *)array{
    baseView=[[UIView alloc] init];
    closeButton=[[UIButton alloc]init];
    arrCategories=[[NSArray alloc] init];
    baseView.backgroundColor = [UIColor clearColor];
    closeButton.backgroundColor=[UIColor clearColor];
 
  
    [closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview: closeButton];
    
    dropDownTableViews = [self makeTableView];
    [dropDownTableViews registerClass:[UITableViewCell class] forCellReuseIdentifier:@"techQuizTable"];
    [baseView addSubview: dropDownTableViews];
    
    arrCategories=array;
    NSLog(@"test %@",arrCategories );   
    
    
    return baseView;
}




-(UITableView *)makeTableView
{
    
    CGRect tableFrame = CGRectMake(0,0,0,0);
    
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
    tableView.layer.borderWidth = 2;
    tableView.layer.borderColor = [[UIColor blackColor] CGColor];
    tableView.backgroundColor=[UIColor whiteColor];
    
    return tableView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"techQuizTable";
    CGRect Label1Frame = CGRectMake(10,17,100,18);
    UILabel *lblTemp;
    UIImageView *imgView;
    lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    [lblTemp setFont:[UIFont fontWithName:@"Helvetica Neue" size:18]];
    lblTemp.tag = 1;
    lblTemp.backgroundColor=[UIColor clearColor];
    lblTemp.numberOfLines=0;
    lblTemp.text=[arrCategories objectAtIndex:indexPath.row];
    [cell.contentView addSubview:lblTemp];
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
   // [cell.contentView addSubview:imgView];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section{
    return [arrCategories count];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     NSString *selectedAnswer = [arrCategories objectAtIndex:indexPath.row];
    [self.delegate cellClicked:selectedAnswer];
     [baseView removeFromSuperview];
    
    
}
-(void)closeView{
    
    [baseView removeFromSuperview];
}
@end
