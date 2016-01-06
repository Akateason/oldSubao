//
//  RootTableView.m
//  Demo_MjRefresh
//
//  Created by TuTu on 15/12/3.
//  Copyright © 2015年 teason. All rights reserved.
//

#import "RootTableView.h"
#import "MJRefresh.h"

@interface RootTableView ()
{
    BOOL b_customLoadMore_isRefreshing ;
}
@property (nonatomic,strong) NSArray *gifImageList ;
@end

@implementation RootTableView
#pragma mark --
#pragma mark - Public
- (void)pullDownRefreshHeader
{
    [self.mj_header beginRefreshing] ;
}

- (BOOL)headerIsRefreshing
{
    return self.mj_header.isRefreshing ;
}

#pragma mark --
#pragma mark - Initialization
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup] ;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup] ;
    }
    return self;
}

- (void)setup
{
    [self MJRefreshConfigure] ;
    [self defaultPublicAPIs] ;
}

- (void)MJRefreshConfigure
{
    NSArray *idleImages = self.gifImageList ; //@[[self.gifImageList firstObject]] ;
    NSArray *pullingImages = self.gifImageList ;
    NSArray *refreshingImages = self.gifImageList ;
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataSelector)];
    [header setImages:idleImages forState:MJRefreshStateIdle];
    [header setImages:pullingImages forState:MJRefreshStatePulling];
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    self.mj_header = header;
    
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataSelector)];
    [footer setImages:idleImages forState:MJRefreshStateIdle];
    [footer setImages:pullingImages forState:MJRefreshStatePulling];
    [footer setImages:refreshingImages forState:MJRefreshStateRefreshing];
    self.mj_footer = footer;
}

- (void)defaultPublicAPIs
{
    self.showRefreshDetail = NO ;
    self.automaticallyLoadMore = NO ;
    self.automaticallyLoadNew = YES ;
//    self.customLoadMore = NO ;
}

#pragma mark --
#pragma mark - Public Properties
- (void)setShowRefreshDetail:(BOOL)showRefreshDetail
{
    _showRefreshDetail = showRefreshDetail ;
    
    ((MJRefreshGifHeader *)self.mj_header).lastUpdatedTimeLabel.hidden = !self.showRefreshDetail;
    ((MJRefreshGifHeader *)self.mj_header).stateLabel.hidden = !self.showRefreshDetail ;
    ((MJRefreshBackGifFooter *)self.mj_footer).stateLabel.hidden = !self.showRefreshDetail ;
}

- (void)setAutomaticallyLoadMore:(BOOL)automaticallyLoadMore
{
    _automaticallyLoadMore = automaticallyLoadMore ;
    
    if (_automaticallyLoadMore)
    {
        self.mj_footer = nil ;
        MJRefreshAutoFooter *autofooter = [MJRefreshAutoFooter footerWithRefreshingTarget:self
                                                                         refreshingAction:@selector(loadMoreDataSelector)] ;
        autofooter.triggerAutomaticallyRefreshPercent = 0.4 ;
        self.mj_footer = autofooter;
    }
}

- (void)setAutomaticallyLoadNew:(BOOL)automaticallyLoadNew
{
    _automaticallyLoadNew = automaticallyLoadNew ;
    
    if (_automaticallyLoadNew) {
        [self.mj_header beginRefreshing] ;
    } else {
        [self.mj_header endRefreshing] ;
    }
}


- (void)setCustomLoadMore:(BOOL)customLoadMore
{
    _customLoadMore = customLoadMore ;
    
    if (customLoadMore == YES)
    {
        self.mj_footer = nil ; // close MJ Refresh Footer .
        b_customLoadMore_isRefreshing = NO ; // b initial .
    }
    else
    {
        NSLog(@" customLoadMore DEFAULT IS `NO` . it's ok .") ;
    }
}

#pragma mark - Private
- (NSArray *)gifImageList
{
    if (!_gifImageList)
    {
        NSMutableArray *tempList = [NSMutableArray array] ;
        for (int i = 0; i < TABLE_HEADER_IMAGES_COUNT; i++)
        {
            UIImage *imgTemp = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d",TABLE_HEADER_IMAGES,i]] ;
            [tempList addObject:imgTemp] ; // DEFAULT MODE IS THIS GIF IMAGES .
        }
        _gifImageList = [NSArray arrayWithArray:tempList] ;
    }
    
    return _gifImageList ;
}

#pragma mark --
#pragma mark - loading methods
- (void)loadNewDataSelector
{
    [self.xt_Delegate loadNewData] ;
    [self headerEnding] ;
}

- (void)headerEnding
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
        [self.mj_header endRefreshing];
    }) ;
}

- (void)loadMoreDataSelector
{
    if (_automaticallyLoadMore)
    {
        dispatch_queue_t queue = dispatch_queue_create("refreshAutoFooter", NULL) ;
        dispatch_async(queue, ^{
            [self.xt_Delegate loadMoreData] ;
            [self footerEnding] ;
        }) ;
        return ;
    }
    else
    {
        [self.xt_Delegate loadMoreData] ;
    }
    
    [self footerEnding] ;
}

- (void)footerEnding
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
        [self.mj_footer endRefreshing];
    }) ;
}

#pragma mark -- if using customLoadMore , U have to WRITE this func in the UIScrollViewDelegate
- (void)rootTableScrollDidEndDragging:(UIScrollView *)scrollView
{
    if (self.customLoadMore == YES) {
        [self loadMoreWithScrollView:scrollView] ;
    }
}

- (void)loadMoreWithScrollView:(UIScrollView *)scrollView
{
    if (self.mj_header.isRefreshing || b_customLoadMore_isRefreshing) return ; // protect loading only once . if in loading break out .
    
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview] ;
    if (translation.y > 0.0) return ; // BREAK in move up direction .
    
    CGPoint offset = scrollView.contentOffset ;
    CGRect bounds = scrollView.bounds ;
    CGSize contentsize = scrollView.contentSize ;
    UIEdgeInsets inset = scrollView.contentInset ;
    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom ;
    CGFloat maximumOffset = contentsize.height ;
    if (contentsize.height <= bounds.size.height) return ;
    
    if ( maximumOffset * 0.8 <= currentOffset) {
        [self loadMoreAction] ;
    }
}

- (void)loadMoreAction
{
    b_customLoadMore_isRefreshing = YES ; // change status into isRefreshing now .
    
//    dispatch_queue_t queue = dispatch_queue_create("TeasonLoadMore", NULL) ;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) ;
    dispatch_async(queue, ^{
        
        [self.xt_Delegate loadMoreData] ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadData] ;
            b_customLoadMore_isRefreshing = NO ;
        }) ;
        
    }) ;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
