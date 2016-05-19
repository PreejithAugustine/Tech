//
//  DropDown.h
//  TechQuiz
//
//  Created by Preejith Augustine on 18/05/16.
//  Copyright © 2016 Preejith Augustine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DropDown;
@protocol DropDownViewDelegate
//@required
- (void)cellClicked:(NSString *)contentLabel;
@end

@interface DropDown : UIView<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView *baseView;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UITableView *dropDownTableViews;
@property (retain, nonatomic) NSArray *arrCategories;
@property (nonatomic, weak) id <DropDownViewDelegate> delegate;


-(UIView *)tableView :(NSArray *)array;
-(UITableView *)makeTableView;

@end

