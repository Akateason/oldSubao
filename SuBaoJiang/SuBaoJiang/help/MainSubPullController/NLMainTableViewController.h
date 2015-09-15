//
//  NLMainTableViewController.h
//  NLScrollPagination
//
//  Created by noahlu on 14-8-1.
//  Copyright (c) 2014年 noahlu<codedancerhua@gmail.com>. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLSubTableViewController.h"
#import "NLPullUpRefreshView.h"
#import "RootCtrl.h"

@interface NLMainTableViewController : RootCtrl <NLPullDownRefreshViewDelegate, NLPullUpRefreshViewDelegate>

@property(nonatomic, strong) UITableView                *tableView;
@property(nonatomic, strong) NLSubTableViewController   *subTableViewController;
@property(nonatomic)         BOOL                       isResponseToScroll;
@property(nonatomic)         BOOL                       m_firstPrivateTime ;

- (void)setTableContentSizeHeight:(float)height ;

- (void)topBarHide:(BOOL)bHide ;

- (void)reSetPullFrame ;    // 在详情页进入选择尺码后调用 .

@end
