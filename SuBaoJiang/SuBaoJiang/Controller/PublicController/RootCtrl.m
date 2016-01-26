//
//  RootCtrl.m
//  Teason
//
//  Created by ; on 14-8-21.
//  Copyright (c) 2014年 TEASON. All rights reserved.
//

#import "RootCtrl.h"
#import "MobClick.h"
#import "SDImageCache.h"

@interface RootCtrl ()
{
    __block XTNetReloader *m_netReloader ;
}
@property (nonatomic,strong) UIImageView *guidingImageView ;
@end

@implementation RootCtrl

- (void)dealloc
{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    self.navigationController.navigationBar.translucent = NO ;
    [MobClick beginLogPageView:self.myTitle] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户点击了返回按钮
    if (self.bOpenClickBackButtonCallBack && [self.navigationController.viewControllers indexOfObject:self] == NSNotFound)
    {
        if ([self respondsToSelector:@selector(iClickedBackButton)])
        {
            [self iClickedBackButton] ;
        }
    }
    
    [super viewWillDisappear:animated] ;
    [MobClick endLogPageView:self.myTitle];
}

- (void)iClickedBackButton
{
    // rewrite this in subClass if necessary .
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory] ;
}

#pragma mark --
#pragma mark - Public
#pragma mark - xtNetReloader
- (void)showNetReloaderWithReloadButtonClickBlock:(ReloadButtonClickBlock)reloadBlock
{
    CGRect rect = APPFRAME ;
    rect.origin.y -= 64.0f ;
    if (!m_netReloader) {
        m_netReloader = [[XTNetReloader alloc] initWithFrame:rect] ;
    }
    m_netReloader.reloadButtonClickBlock = reloadBlock ;
    
    if (![m_netReloader superview]) {
        [m_netReloader showInView:self.view] ;
    }
}
- (void)dismissNetReloader
{
    [m_netReloader dismiss] ;

//    for (UIView *sub in [self.view subviews]) {
//        if ([sub isKindOfClass:[XTNetReloader class]]) {
//            [(XTNetReloader *)sub dismiss] ;
//        }
//    }
}

#pragma mark --
#pragma mark - back Button Set
- (void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --
#pragma mark - setter
#pragma mark - Set BOOL is delete bar button
- (void)setGuidingStrList:(NSArray *)guidingStrList
{
    _guidingStrList = guidingStrList ;
    
    _guidingIndex = 0 ;
    self.guidingImageView.image = [UIImage imageNamed:guidingStrList[_guidingIndex]] ;
}

- (void)setIsDelBarButton:(BOOL)isDelBarButton
{
    _isDelBarButton = isDelBarButton ;
    if (isDelBarButton)
    {
        self.navigationItem.leftBarButtonItem = nil ;
        self.navigationItem.backBarButtonItem = nil ;
    }
}

#pragma mark --
#pragma mark - Getter
- (NSString *)myTitle
{
    if (!_myTitle) {
        _myTitle = self.title ;
    }
    return _myTitle ;
}

- (UIImageView *)guidingImageView
{
    if (!_guidingImageView)
    {
        _guidingImageView = [[UIImageView alloc] init] ;
        _guidingImageView.alpha = 0. ;
        CGRect rectGuiding = APPFRAME ;
        rectGuiding.size.height = ( DEVICE_IS_IPHONE5 ) ? APPFRAME.size.height : APPFRAME.size.width / 9.0 * 16.0 ;
        _guidingImageView.frame = rectGuiding ;
        _guidingImageView.backgroundColor = nil ;
        _guidingImageView.userInteractionEnabled = YES ;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGuidingImageView)] ;
        [_guidingImageView addGestureRecognizer:tapGesture] ;
    }
    
    if (![_guidingImageView superview])
    {
        [[UIApplication sharedApplication].keyWindow addSubview:_guidingImageView] ;
        [UIView animateWithDuration:0.5
                         animations:^{
            _guidingImageView.alpha = 1. ;
        }] ;
    }
    
    return _guidingImageView ;
}

- (void)clickGuidingImageView
{
    _guidingIndex ++ ;

    if (_guidingIndex > self.guidingStrList.count - 1)
    {
        [self.guidingImageView removeFromSuperview] ;
    }
    else
    {
        self.guidingImageView.image = [UIImage imageNamed:self.guidingStrList[_guidingIndex]] ;
    }
}

#pragma mark --
#pragma mark - hide tab bar
- (void)makeTabBarHidden:(BOOL)hide
{
    [self makeTabBarHidden:hide animated:NO] ;
}

- (void)makeTabBarHidden:(BOOL)hide animated:(BOOL)animated
{
    if ( [self.tabBarController.view.subviews count] < 2 ) return;
    self.tabBarController.tabBar.hidden = hide ;
    UIView *contentView ;
    if ( [[self.tabBarController.view.subviews firstObject] isKindOfClass:[UITabBar class]] )
    {
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    }
    else
    {
        contentView = [self.tabBarController.view.subviews firstObject];
    }
    CGRect newFrame ;
    if ( hide )
    {
        newFrame = APPFRAME ;
    }
    else
    {
        newFrame = CGRectMake(APPFRAME.origin.x,
                                       APPFRAME.origin.y,
                                       APPFRAME.size.width,
                                       APPFRAME.size.height - MY_TABBAR_HEIGHT) ;
    }
    if (animated)
    {
        [UIView animateWithDuration:0.35f animations:^{
            contentView.frame = newFrame ;
        }] ;
    }
    else
    {
        contentView.frame = newFrame ;
    }
}

@end

