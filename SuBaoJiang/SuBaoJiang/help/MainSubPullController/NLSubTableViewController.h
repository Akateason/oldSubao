//
//  NLSubTableViewController.h
//  NLScrollPagination
//
//  Created by noahlu on 14-8-1.
//  Copyright (c) 2014年 noahlu<codedancerhua@gmail.com>. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLPullDownRefreshView.h"
#import "ColorsHeader.h"


@interface NLSubTableViewController : UITableViewController <UITableViewDelegate,UITableViewDataSource>
 
@property(nonatomic, strong) UITableView           *tableView;
@property(nonatomic, weak)   UIViewController      *mainTableViewController; //UITableViewController
@property(nonatomic, strong) NLPullDownRefreshView *pullFreshView;


@end
