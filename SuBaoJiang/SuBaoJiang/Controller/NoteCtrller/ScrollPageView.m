//
//  ScrollPageView.m
//  Teason
//
//  Created by ; on 14-8-21.
//  Copyright (c) 2014年 TEASON. All rights reserved.
//

#import "ScrollPageView.h"
#import "ColorsHeader.h"

@interface ScrollPageView ()
{
//    Cmt2MeTable     *m_cmt2meTable ;
//    Praise2MeTable  *m_praise2meTable ;
//    Note2MeTable    *m_note2meTable ;
}
@property (nonatomic) int prePage ; // 前一页, default is -1 ;
@end

@implementation ScrollPageView

@synthesize mCurrentPage ,prePage = _prePage;

- (void)setPrePage:(int)prePage
{
    _prePage = prePage ;
    NSLog(@"prepage : %d",prePage) ;
    if (self.prePage != -1)
    {
        [self updateAlreadyWithIndex:prePage] ;
    }
    
}



#pragma mark -- Initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        mNeedUseDelegate = YES;
        [self commInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        // Initialization code
        mNeedUseDelegate = YES ;
        [self commInit] ;
        NSLog(@"_pageView : %@", NSStringFromCGRect(self.frame)) ;
    }
    
    return self;
}

- (void)commInit
{
    self.prePage = -1 ;
    
    if (_contentItems == nil)
    {
        _contentItems = [[NSMutableArray alloc] init];
    }
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.pagingEnabled = YES ;
        _scrollView.delegate = self     ;
    }
    
    [self addSubview:_scrollView] ;
}

- (void)dealloc
{
    [_contentItems removeAllObjects],_contentItems= nil;
}

#pragma mark - public

- (void)updateAlreadyWithIndex:(NSInteger)index
{
    [self.delegate clearTopSegForPrepageIndex:index] ;
    
//    switch (index)
//    {
//        case 0:
//        {
//            [m_cmt2meTable updateAlreadyReadlist] ;
//        }
//            break;
//        case 1:
//        {
//            [m_praise2meTable updateAlreadyReadlist] ;
//        }
//            break;
//        case 2:
//        {
//            [m_note2meTable updateAlreadyReadlist] ;
//        }
//            break;
//        default:
//            break;
//    }
}

// setup content
- (void)setContentOfTables:(NSInteger)aNumerOfTables
{
//    for (int i = 0; i < aNumerOfTables; i++)
//    {
//        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)] ;
//        
//        if (i == 0)
//        {
//            //评论
//            CGRect rect = CGRectZero ;
//            rect.size = self.frame.size ;
//            m_cmt2meTable = [[Cmt2MeTable alloc] initWithMyFrame:rect] ;
//            [scroll addSubview:m_cmt2meTable] ;
//        }
//        else if (i == 1)
//        {
//            //点赞
//            CGRect rect = CGRectZero ;
//            rect.size = self.frame.size ;
//            m_praise2meTable = [[Praise2MeTable alloc] initWithMyFrame:rect] ;
//            [scroll addSubview:m_praise2meTable] ;
//        }
//        else if (i == 2)
//        {
//            //系统
//            CGRect rect = CGRectZero ;
//            rect.size = self.frame.size ;
//            m_note2meTable = [[Note2MeTable alloc] initWithMyFrame:rect] ;
//            [scroll addSubview:m_note2meTable] ;
//        }
//
//        [_scrollView    addSubview:scroll]      ;
//        [_contentItems  addObject:scroll]       ;
//        
//    }
    
    [_scrollView setContentSize:CGSizeMake(self.frame.size.width * aNumerOfTables, self.frame.size.height)] ;
}

// fresh page
- (UIScrollView *)freshContentTableAtIndex:(NSInteger)aIndex
{
    
    if (_contentItems.count < aIndex) return nil ;
//    switch (aIndex) {
//        case 0:
//        {
//            //评论
//            [m_cmt2meTable pulldownManually] ;
//        }
//            break;
//        case 1:
//        {
//            //点赞
//            [m_praise2meTable pulldownManually] ;
//        }
//            break;
//        case 2:
//        {
//            //系统
//            [m_note2meTable pulldownManually] ;
//        }
//            break;
//        default:
//            break;
//    }
//    
    return nil ;
}


// 移动ScrollView到某个页面
- (void)moveScrollowViewAthIndex:(NSInteger)aIndex
{
    mNeedUseDelegate = NO;
    
    self.prePage = mCurrentPage ;
    mCurrentPage = aIndex;
    
    [self moveToNewPage] ;
    
    CGRect vMoveRect = CGRectMake(self.frame.size.width * aIndex, 0, self.frame.size.width, self.frame.size.width);
    [_scrollView scrollRectToVisible:vMoveRect animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    mNeedUseDelegate = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = ( _scrollView.contentOffset.x + self.frame.size.width / 2.0 ) / self.frame.size.width;
    
    if (mCurrentPage == page) return;
    
    if (mNeedUseDelegate)
    {
        self.prePage = mCurrentPage ;
    }
    
    mCurrentPage = page;
    
    [self moveToNewPage] ;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        
    }
}

#pragma mark - move To New Page
- (void)moveToNewPage
{
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)] && mNeedUseDelegate)
    {
        [_delegate didScrollPageViewChangedPage:mCurrentPage] ;
    }
}

#pragma mark - HomePageViewDelegate
- (void)shutDownApp
{
    [self.delegate terminateApp] ;
}

@end
