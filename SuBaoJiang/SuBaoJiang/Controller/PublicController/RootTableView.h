//
//  RootTableView.h
//  SuBaoJiang
//
//  Created by apple on 15/6/26.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
//#import "EGORefreshTableFooterView.h"


@protocol RootTableViewDelegate <NSObject>
- (BOOL)doSthWhenfreshingHeader ;
- (BOOL)doSthWhenfreshingFooter ;
@end


@protocol RootTableViewFinished <NSObject>
@optional
- (void)headerRefreshFinished ;
- (void)footerRefreshFinished ;
@end

@interface RootTableView : UITableView<EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView   *_refreshHeaderView ;
    BOOL                        _reloadingHead      ;
    BOOL                        _reloadingFoot      ;
}

@property (nonatomic,retain) id <RootTableViewDelegate> rootDelegate ;
@property (nonatomic,retain) id <RootTableViewFinished> rootFinished ;

@property (nonatomic)       BOOL canBeAutoLoadingMore ; // DEFAULT IS FALSE ;

/*
 ** default NO ;
 ** if YES     : when no data is return  , show a img in the front ;
 **/
@property (nonatomic) BOOL isNetSuccess ;

/*
 **  pull down Manually and fresh header
 **/
- (void)pulldownManually ;

/*
 **  write in scroll view delegate
 **/
- (void)rootTableScrollDidScroll:(UIScrollView *)scrollView ;
- (void)rootTableScrollDidEndDragging:(UIScrollView *)scrollView ;

// set refresh view frame ;
//- (void)setRefreshViewFrame ;

@end
