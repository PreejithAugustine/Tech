//
//  UITableViewController+TechCategories.m
//  TechQuiz
//
//  Created by Preejith Augustine on 13/05/16.
//  Copyright © 2016 Preejith Augustine. All rights reserved.
//

#import "UIView+TechCategories.h"

@implementation UIView (TechCategories)




+ (UITableView *)makeTableView {
    CGFloat x = 20;
    CGFloat y = 50;
    CGFloat width = 100;
    CGFloat height = 120;
    CGRect tableFrame = CGRectMake(x, y, width, height);
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    
    tableView.rowHeight = 30;
    tableView.sectionFooterHeight = 22;
    tableView.sectionHeaderHeight = 22;
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.userInteractionEnabled = YES;
    tableView.bounces = NO;
    tableView.backgroundColor=[UIColor redColor];
    //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    return tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dropdownCell"];
            if (indexPath.row==0) {
            cell.textLabel.text = @"All Categories";
        }else {
            cell.textLabel.text =@"Second categories";
        }
  
    
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}


@end
