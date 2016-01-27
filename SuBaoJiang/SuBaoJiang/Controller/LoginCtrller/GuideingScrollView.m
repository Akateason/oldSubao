//
//  GuideingScrollView.m
//  SuBaoJiang
//
//  Created by apple on 15/7/1.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "GuideingScrollView.h"
#import "GuideFirstCtrller.h"
#import "GuideSecondCtrller.h"
#import "GuideThirdCtrller.h"
#import "GuideFourthCtrller.h"
#import "ThirdLoginCtrller.h"

@interface GuideingScrollView () <UIScrollViewDelegate,ThirdLoginCtrllerDelegate>
{
    NSArray             *m_guidelist ;
    int                 m_pre ;
    ThirdLoginCtrller   *m_loginCtrller ;
    GuideFirstCtrller   *m_firstCtrller ;
    GuideSecondCtrller  *m_secondCtrller ;
    GuideThirdCtrller   *m_thirdCtrller ;
    GuideFourthCtrller  *m_fourthCtrller ;
}
@property (nonatomic,strong)UIPageControl *pageCtrl ;
@property (nonatomic,strong)UIButton      *bt_Skip ;
@end

@implementation GuideingScrollView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews] ;

    [self showScrollView] ;
}

- (void)startAnimation
{
    [m_firstCtrller startAnimate] ;
}

#pragma mark --
#pragma mark - showScrollView
- (void)showScrollView
{
    if ([m_loginCtrller.view superview] != nil) return ;
    
    m_firstCtrller = [[GuideFirstCtrller alloc] init] ;
    m_secondCtrller = [[GuideSecondCtrller alloc] init] ;
    m_thirdCtrller = [[GuideThirdCtrller alloc] init] ;
    m_fourthCtrller = [[GuideFourthCtrller alloc] init] ;
    m_loginCtrller = [[ThirdLoginCtrller alloc] init] ;
    
    m_loginCtrller.delegate = self ;
    m_loginCtrller.bAboutUs = self.isAboutUS ;
    m_guidelist = @[m_firstCtrller,m_secondCtrller,m_thirdCtrller,m_fourthCtrller,m_loginCtrller] ;
    
    m_pre = 0 ;
    self.delegate = self ;
    self.pagingEnabled = YES ;
    self.showsVerticalScrollIndicator = NO ;
    self.showsHorizontalScrollIndicator = NO ;
    self.bounces = NO ;
    self.contentSize = CGSizeMake(APPFRAME.size.width * m_guidelist.count, APPFRAME.size.height ) ;
    
    int _x = 0 ;
    
    for (int i = 1; i <= m_guidelist.count; i++)
    {
        UIViewController *tempCtrl = [m_guidelist objectAtIndex:i - 1];
        CGRect tempRec = tempCtrl.view.frame ;
        CGPoint point = CGPointMake(_x, 0) ;
        tempRec.origin = point ;
        tempRec.size = APPFRAME.size ;
        
        tempCtrl.view.frame = tempRec ;
        [self addSubview:tempCtrl.view] ;
        _x += APPFRAME.size.width ;
    }
    
//    [m_firstCtrller startAnimate] ;
    
    [self pageCtrl] ;
//    [self bt_Skip] ;
}



- (UIPageControl *)pageCtrl
{
    if (!_pageCtrl)
    {
        _pageCtrl = [[UIPageControl alloc] init] ;
        _pageCtrl.numberOfPages = [m_guidelist count] ;
        _pageCtrl.currentPage = 0 ;
        _pageCtrl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.2 alpha:0.5] ;
        _pageCtrl.pageIndicatorTintColor = [UIColor colorWithWhite:0.35 alpha:0.1] ;
        _pageCtrl.center = CGPointMake(APPFRAME.size.width / 2, APPFRAME.size.height - 20.0) ;
        
        if (![_pageCtrl superview])
        {
            [self.currentCtrller.view addSubview:_pageCtrl] ;
        }
    }
    
    return _pageCtrl ;
}

- (UIButton *)bt_Skip
{
    if (!_bt_Skip)
    {
        _bt_Skip = [[UIButton alloc] init] ;
        _bt_Skip.layer.cornerRadius = 8.0 ;
        _bt_Skip.backgroundColor = [UIColor colorWithRed:1.0/255.0
                                                   green:1.0/255.0
                                                    blue:1.0/255.0 alpha:0.2] ;
        
        [_bt_Skip setTitle:@"跳过" forState:0] ;
        [_bt_Skip setTitleColor:[UIColor colorWithWhite:1 alpha:0.9] forState:0] ;
        _bt_Skip.titleLabel.font = [UIFont systemFontOfSize:16.0] ;
        
        [_bt_Skip addTarget:self
                     action:@selector(skipClickAction)
           forControlEvents:UIControlEventTouchUpInside] ;
        
        if (![_bt_Skip superview])
        {
            CGRect rect = CGRectZero ;
            rect.size = CGSizeMake(49.0, 24.0) ;
            float flex = 20 ;
            rect.origin.x = APPFRAME.size.width - flex - 49.0;
            rect.origin.y = flex ;
            _bt_Skip.frame = rect ;
            
            [self.currentCtrller.view addSubview:_bt_Skip] ;
        }
    }
    
    return _bt_Skip ;
}

- (void)skipClickAction
{
    NSLog(@"skipClickAction") ;
    
    [self.guidingDelegate seeMore] ;
    
//    CGFloat wid = APPFRAME.size.width * 4 ;
//    self.pageCtrl.currentPage = 4 ;
//    [self scrollRectToVisible:CGRectMake(wid, 0, APPFRAME.size.width, APPFRAME.size.height)
//                     animated:YES] ;
}


#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    int current = scrollView.contentOffset.x / APPFRAME.size.width;
    self.pageCtrl.currentPage = current ;
    
    m_pre = current ;
    NSLog(@"current,%d",current) ;
    
    switch (current)
    {
        case 0:
        {
            [m_firstCtrller startAnimate] ;
        }
            break;
        case 1:
        {
            [m_secondCtrller startAnimate] ;
        }
            break;
        case 2:
        {
            [m_thirdCtrller startAnimate] ;
        }
            break;
        case 3:
        {
            [m_fourthCtrller startAnimate] ;
        }
            break;
        case 4:
        {
            [m_loginCtrller startAnimate] ;
        }
            break;
        default:
            break;
    }
}

#pragma mark - ThirdLoginCtrllerDelegate
- (void)logSelf
{
    [self.guidingDelegate logSelf] ;
}

- (void)seeMore
{
    [self.guidingDelegate seeMore] ;
}

@end
