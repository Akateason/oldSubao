//
//  NLMainTableViewController.m
//  NLScrollPagination
//
//  Created by noahlu on 14-8-1.
//  Copyright (c) 2014年 noahlu<codedancerhua@gmail.com>. All rights reserved.
//

#import "NLMainTableViewController.h"
#import "NLPullUpRefreshView.h"


#define IOS7TOPEDGET            0.0f


@interface NLMainTableViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    CGSize      m_tempMainTableContentSize ; // 始终保存着的, 记录主table的contentsize
}

@property(nonatomic, strong)NLPullUpRefreshView *pullFreshView;
@property(nonatomic) NSInteger refreshCounter ;

@end

@implementation NLMainTableViewController
@synthesize m_firstPrivateTime ;

- (void)reSetPullFrame
{
    self.tableView.contentInset = UIEdgeInsetsMake(IOS7TOPEDGET, 0, 0, 0);
// maintable重绘之后，contentsize要重新加上offset
//    self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height + 50.0) ;
    self.tableView.contentSize = m_tempMainTableContentSize ;
    
    self.isResponseToScroll     = YES   ;
    self.tableView.bounces      = YES   ;
    self.pullFreshView.hidden   = NO    ;
    [self topBarHide:NO] ;
    
    [self resetFrames] ;
}


- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView ;

//    self.tableView.contentInset = UIEdgeInsetsMake(IOS7TOPEDGET, 0, 0, 0);
}

- (void)setTableContentSizeHeight:(float)height
{
    self.tableView.contentSize = CGSizeMake(APPFRAME.size.width, height) ;

    m_tempMainTableContentSize = self.tableView.contentSize ; //
    
    [self addRefreshView]   ;

    [self resetFrames] ;
}

- (void)setSubTableViewController:(NLSubTableViewController *)subTableViewController
{
    _subTableViewController = subTableViewController ;
    
    [self addSubPage] ;
    [self resetFrames] ;

}


- (void)topBarHide:(BOOL)bHide
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_firstPrivateTime = YES ;
    
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone ;
    self.view.backgroundColor       = COLOR_BACKGROUND ;
    self.isResponseToScroll = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//
    [self resetFrames] ;
}


- (void)addRefreshView
{
    if (!self.pullFreshView)
    {
        float originY = m_tempMainTableContentSize.height ;
        self.pullFreshView = [[NLPullUpRefreshView alloc] initWithFrame:CGRectMake(0, originY, self.view.frame.size.width, 50.f)];
        self.pullFreshView.backgroundColor = [UIColor whiteColor];
        [self.pullFreshView clearStyle] ;
    }
    
    if (!self.pullFreshView.superview)
    {
        [self.pullFreshView setupWithOwner:self.tableView delegate:self];
    }
}

- (void)addSubPage
{
//    if (!self.subTableViewController) return;
    
    self.subTableViewController.mainTableViewController = self ;
    self.subTableViewController.tableView.frame = CGRectMake(0, m_tempMainTableContentSize.height + 50.0f, self.view.frame.size.width, self.tableView.frame.size.height) ;
    [self.tableView addSubview:self.subTableViewController.tableView] ;
    
}

- (void)resetFrames
{

    NSLog(@"self.tableView.contentSize : %@",NSStringFromCGSize(self.tableView.contentSize)) ;
    NSLog(@"self.pullFreshView.frame : %@",NSStringFromCGRect(self.pullFreshView.frame)) ;
    NSLog(@"self.subTableViewController.tableView.frame : %@",NSStringFromCGRect(self.subTableViewController.tableView.frame)) ;
    NSLog(@"m_tempMainTableContentSize : %@",NSStringFromCGSize(m_tempMainTableContentSize)) ;
    
    if (self.tableView)
    {
        self.tableView.contentSize = CGSizeMake(m_tempMainTableContentSize.width, m_tempMainTableContentSize.height);
    }
    
    if (self.pullFreshView)
    {
        CGRect pullFreshViewRect = self.pullFreshView.frame ;
        pullFreshViewRect.origin.x = 0 ;
        pullFreshViewRect.origin.y = m_tempMainTableContentSize.height;
        pullFreshViewRect.size.height = 50.0f ;
        
        self.pullFreshView.frame = pullFreshViewRect ;
    }
    
    if (self.subTableViewController)
    {
        self.subTableViewController.tableView.frame = CGRectMake(0, m_tempMainTableContentSize.height + 50.0f , self.view.frame.size.width, self.tableView.frame.size.height) ;
    }
    
    NSLog(@"1self.tableView.contentSize : %@",NSStringFromCGSize(self.tableView.contentSize)) ;
    NSLog(@"1self.pullFreshView.frame : %@",NSStringFromCGRect(self.pullFreshView.frame)) ;
    NSLog(@"1self.subTableViewController.tableView.frame : %@",NSStringFromCGRect(self.subTableViewController.tableView.frame)) ;
    NSLog(@"1m_tempMainTableContentSize : %@",NSStringFromCGSize(m_tempMainTableContentSize)) ;
    
}


#pragma mark --
- (void)pullUpRefreshDidFinish
{
    if (!self.refreshCounter)
    {
        self.refreshCounter = 0;
    }
    
    // 上拉分页动画
    [UIView animateWithDuration:0.3 animations:^{
        
        self.tableView.contentInset = UIEdgeInsetsMake(- m_tempMainTableContentSize.height - 50.0f,0,0,0) ;
        
        [self.subTableViewController.tableView reloadData] ;
        
    }] ;
    
    self.isResponseToScroll = NO;
    self.tableView.bounces = NO;
    [self.pullFreshView stopLoading];
    self.pullFreshView.hidden = YES;
    
    [self topBarHide:YES] ;
}

- (void)pullDownRefreshDidFinish
{
    [self.subTableViewController.pullFreshView stopLoading];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(IOS7TOPEDGET, 0, 0, 0);
        // maintable重绘之后，contentsize要重新加上offset
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, m_tempMainTableContentSize.height ) ;
    }];
    
    self.tableView.bounces = YES    ;
    self.isResponseToScroll = YES   ;
    self.pullFreshView.hidden = NO  ;
    
    [self topBarHide:NO] ;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.isResponseToScroll) {
        [self.pullFreshView scrollViewWillBeginDragging:scrollView];
    } else {
        [self.subTableViewController.pullFreshView scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isResponseToScroll) {
        [self.pullFreshView scrollViewDidScroll:scrollView];
    } else {
        [self.subTableViewController.pullFreshView scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isResponseToScroll) {
        [self.pullFreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    else {
        [self.subTableViewController.pullFreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (self.isResponseToScroll)
    {
        [self.pullFreshView scrollViewDidEndDecelerating:scrollView];
    }
 
}


@end
