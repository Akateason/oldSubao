//
//  RootTableView.m
//  SuBaoJiang
//
//  Created by apple on 15/6/26.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "RootTableView.h"
#import "YXSpritesLoadingView.h"
#import "XTHudManager.h"
#import "NSObject+MKBlockTimer.h"

@implementation RootTableView

#pragma mark -- initial
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupHeaderFooter] ;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupHeaderFooter] ;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupHeaderFooter] ;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setupHeaderFooter] ;
    }
    return self;
}

- (void)setupHeaderFooter
{
    [self setHeaderRefreshView] ;
}

#pragma mark -- Public
- (void)pulldownManually
{
    if (_reloadingHead) {
        return ;
    }
    
    [self reloadTableViewDataSource]    ;
    [self doneLoadingTableViewData]     ;
}

- (void)rootTableScrollDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)rootTableScrollDidEndDragging:(UIScrollView *)scrollView
{
    // refresh more
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    // load more
    [self loadMoreWithScrollView:scrollView] ;
}

- (void)loadMoreWithScrollView:(UIScrollView *)scrollView
{
    if (_reloadingFoot || _reloadingHead) return ; // protect loading only once . if in loading break

    
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize contentsize = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
    CGFloat maximumOffset = contentsize.height;
//    NSLog(@"maximumOffset : %f",maximumOffset) ;
//    NSLog(@"currentOffset : %f",currentOffset) ;
    
    if (contentsize.height <= bounds.size.height) return ;
    
    CGFloat alarmDistance = self.canBeAutoLoadingMore ? maximumOffset / 4.0 : 0 ;

    if (maximumOffset <= currentOffset + alarmDistance || maximumOffset <= currentOffset)
    {
        [self loadMoreAction];
    }
}

- (void)loadMoreAction
{
    _reloadingFoot = YES ;
    
    dispatch_queue_t queue = dispatch_queue_create("LoadMore", NULL) ;
    dispatch_async(queue, ^{
        BOOL b = [self.rootDelegate doSthWhenfreshingFooter] ;
        if (b)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData] ;
                _reloadingFoot = NO ;
            }) ;
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showNothing] ;
                _reloadingFoot = NO ;
            }) ;
        }
    }) ;
}

- (BOOL)dataOperationWhenHeaderLoading
{
    return [self.rootDelegate doSthWhenfreshingHeader] ;
}

#pragma mark -- 
#pragma mark - Properties

- (void)setIsNetSuccess:(BOOL)isNetSuccess
{
    _isNetSuccess = isNetSuccess ;
    
    [self performSelectorOnMainThread:@selector(setBackgroundWithWifiSuccess:)
                           withObject:[NSNumber numberWithBool:isNetSuccess]
                        waitUntilDone:NO] ;
}

- (void)setBackgroundWithWifiSuccess:(id)obj
{
    BOOL bSuccess = [obj boolValue] ;
    
    if (bSuccess)
    {
        [self setBackgroundView:nil] ;
    }
    else
    {
        UIView *nowifiView = [[[NSBundle mainBundle] loadNibNamed:@"NoWifiView" owner:self options:nil] lastObject] ;
        nowifiView.frame = self.frame ;
        [self setBackgroundView:nowifiView] ;
    }
}

#pragma mark --
#pragma mark - initial ego
// refresh Table Initial
- (void)setHeaderRefreshView
{
    if (_refreshHeaderView == nil)
    {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        [self addSubview:_refreshHeaderView];
    }
    
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
}


#pragma mark --
#pragma mark - EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [YXSpritesLoadingView showWithText:WD_HUD_GOON
                             andShimmering:NO
                             andBlurEffect:NO] ;
    }) ;
    
    [self reloadTableViewDataSource]    ;
    [self doneLoadingTableViewData]     ;
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _reloadingHead; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date]; // should return date data source was last changed
}

#pragma mark --
#pragma mark - Refresh Header Table
#pragma mark - Header Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource
{
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    _reloadingHead = YES;
}

- (void)doneLoadingTableViewData
{
    __block BOOL bSuccess ;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0) ;
    dispatch_async(queue, ^{
        
        __block unsigned int seconds = [self logTimeTakenToRunBlock:^{
            
            bSuccess = [self dataOperationWhenHeaderLoading] ;
            
        } withPrefix:@"result time"] ;
        
        float smallsec = seconds / 1000.0f ;
        
        if (WAIT_TIME > smallsec)
        {
            float sleepTime = WAIT_TIME - smallsec ;
            
            dispatch_async(dispatch_get_main_queue(), ^() {
                sleep(sleepTime) ;
                [self finishPullUpMainThreadUIWithSuccess:bSuccess] ;
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^() {
                [self finishPullUpMainThreadUIWithSuccess:bSuccess] ;
            });
        }
        
    }) ;
    
}

- (void)finishPullUpMainThreadUIWithSuccess:(BOOL)bSuccess
{
    [YXSpritesLoadingView dismiss] ;
    
    [self reloadData] ;
    
    //  model should call this when its done loading
    
    _reloadingHead = NO ;
    
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self] ;
    
    [self.rootFinished headerRefreshFinished] ;
}

- (void)showNothing
{
    [XTHudManager showWordHudWithTitle:WD_HUD_NOMORE delay:1.0] ;
}


@end
