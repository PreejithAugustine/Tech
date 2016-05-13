//
//  DropdownList.m
//  Twazer
//
//  Created by Citrus Informatics on 10/07/15.
//  Copyright (c) 2015 Citrus Informatics. All rights reserved.
//

#import "DropdownList.h"
//#import "UIColor+Twazer.h"
//#import "CategoryClass.h"
//#import "Product.h"

@implementation DropdownList

- (void)viewDidLoad {
    
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"currentPage"] isEqualToString:@"filters"]) {
//        _tableViewDataSourceArray = @[@"All Categories",@"Books/Notes",@"Furniture",@"Electronics",@"Clothes",@"Tickets",@"Services",@"Other"];
//    }else {
//        _tableViewDataSourceArray = @[@"Books/Notes",@"Furniture",@"Electronics",@"Clothes",@"Tickets",@"Services",@"Other"];
//    }
    allCategFlag = false;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"page"] isEqualToString:@"dashboard"]) {
        allCategFlag = true;
    }
    
   // appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
//    _tableViewDataSourceArray = [[NSMutableArray alloc] initWithArray:(NSArray*)appDelegate.categoryItemsArray];
//    [_tableViewDataSourceArray addObject:@"All Categories"];
    
    _dropdownTableView = [self makeTableView];
    [_dropdownTableView setBackgroundColor:[UIColor clearColor]];
    [_dropdownTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_dropdownTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:_dropdownTableView];
    [_dropdownTableView flashScrollIndicators];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.dropdownTableView performSelector:@selector(flashScrollIndicators) withObject:nil afterDelay:0];
}

- (UITableView *)makeTableView {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = self.parentWidth;
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
    //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    return tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return _tableViewDataSourceArray.count;
    if (allCategFlag) {
     return    1;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dropdownCell"];
    if (allCategFlag) {
        if (indexPath.row==0) {
            cell.textLabel.text = @"All Categories";
        }else {
          //  cell.textLabel.text = [appDelegate.categoryItemsArray[indexPath.row-1] objectForKey:@"categString"];
        }
    }
    else {
        //cell.textLabel.text = [appDelegate.categoryItemsArray[indexPath.row] objectForKey:@"categString"];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    if (allCategFlag) {
        if (indexPath.row==0) {
            [self.delegate cellClicked:@"All Categories"];
        }else {
           // [self.delegate cellClicked:[appDelegate.categoryItemsArray[indexPath.row-1] objectForKey:@"categString"]];
        }
    }else {
       // [self.delegate cellClicked:[appDelegate.categoryItemsArray[indexPath.row] objectForKey:@"categString"]];
    }
}

@end
