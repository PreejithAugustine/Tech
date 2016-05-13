//
//  DropdownList.h
//  Twazer
//
//  Created by Citrus Informatics on 10/07/15.
//  Copyright (c) 2015 Citrus Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@protocol DropdownListDelegate <NSObject>

@required

- (void)cellClicked:(NSString *)contentLabel;

@end

@interface DropdownList : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    //AppDelegate *appDelegate;
    BOOL allCategFlag;
}

@property (nonatomic, weak) id<DropdownListDelegate> delegate;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *baseView;
@property (strong, nonatomic) NSMutableArray *tableViewDataSourceArray;
@property (nonatomic, nonatomic) float tableSpan;
@property (strong, nonatomic) UITableView *dropdownTableView;
@property (nonatomic, nonatomic) float parentWidth;

@end


