//
//  RootTableView.h
//  Demo_MjRefresh
//
//  Created by TuTu on 15/12/3.
//  Copyright © 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *TABLE_HEADER_IMAGES        = @"sbj_" ;
static int       TABLE_HEADER_IMAGES_COUNT  = 3 ;

@protocol RootTableViewDelegate <NSObject>
- (void)loadNewData ;
- (void)loadMoreData ;
@end

@interface RootTableView : UITableView

//1 PUBLIC FUNCTIONS
- (void)pullDownRefreshHeader ;
- (BOOL)headerIsRefreshing ;

//2 DELEGATE
@property (nonatomic,weak) id <RootTableViewDelegate> xt_Delegate ; // SET myDelegate TO YOUR CTRLLER

//3 PUBLIC APIS
// using MJRefresh
@property (nonatomic) BOOL showRefreshDetail ;      // DEFAULT IS `NO`  -> ONLY GIF IMAGES , SHOW WORDS WHEN IT BECOMES `YES`
@property (nonatomic) BOOL automaticallyLoadNew ;   // DEFAULT IS `YES` -> EVERYTIME INITIAL WITH AUTO LOAD NEW . CHANGE IT TO `NO` IF NECESSARY .
@property (nonatomic) BOOL automaticallyLoadMore ;  // DEFAULT IS `NO`  -> MANUALLY LOADING . AUTOMATICALLY LOAD WHEN IT BECOMES `YES`

// using Teason's loadMore . by whole tableview.contentSize.y 's percentage .
@property (nonatomic) BOOL customLoadMore ; // using this property .  . default is `NO` . if 'YES' MJ refresh Footer will Close
// IF using customLoadMore , U have to WRITE this func in the UIScrollViewDelegate
- (void)rootTableScrollDidEndDragging:(UIScrollView *)scrollView ;

@end
