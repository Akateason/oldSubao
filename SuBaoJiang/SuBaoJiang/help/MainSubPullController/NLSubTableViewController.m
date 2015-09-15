//
//  NLSubTableViewController.m
//  NLScrollPagination
//
//  Created by noahlu on 14-8-1.
//  Copyright (c) 2014年 noahlu<codedancerhua@gmail.com>. All rights reserved.
//

#import "NLSubTableViewController.h"

@interface NLSubTableViewController () 


@end

@implementation NLSubTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_BACKGROUND ;
    
    if (self.tableView == nil)
    {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];  // style:UITableViewStyleGrouped
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
    }
    
    self.tableView.frame = self.view.bounds ;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addRefreshView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
//    self.navigationController.navigationBar.translucent = YES ;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    
    
}



- (void)addRefreshView
{
    if (self.pullFreshView == nil)
    {
        self.pullFreshView = [[NLPullDownRefreshView alloc] initWithFrame:CGRectMake(0, - 50.f, self.view.frame.size.width, 50.f)];
        self.pullFreshView.backgroundColor = [UIColor whiteColor];
    }
    
    if (!self.pullFreshView.superview)
    {
        [self.pullFreshView setupWithOwner:self.tableView delegate:(id<NLPullDownRefreshViewDelegate>)self.mainTableViewController];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.pullFreshView scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.pullFreshView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.pullFreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}



@end
