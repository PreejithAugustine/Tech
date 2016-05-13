//
//  UITableViewController+TechCategories.h
//  TechQuiz
//
//  Created by Preejith Augustine on 13/05/16.
//  Copyright © 2016 Preejith Augustine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TechCategories) <UITableViewDataSource,UITableViewDelegate>


+ (UITableView *)makeTableView;

@end
