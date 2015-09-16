//
//  RootCtrl.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-21.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "RootCtrl.h"
#import "MobClick.h"
#import "SDImageCache.h"

@interface RootCtrl ()
{
    UIImageView *m_nothingPicImgView ;
}
@property (nonatomic,strong) UIImageView *guidingImageView ;
@end

@implementation RootCtrl

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
    
//  initialAudioPlayer
//    [self initialAudioPlayer] ;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
//  NOT translucent
    self.navigationController.navigationBar.translucent = NO ;
    
    [MobClick beginLogPageView:self.myTitle];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    
    [m_nothingPicImgView removeFromSuperview] ;
    m_nothingPicImgView = nil ;
    
    [MobClick endLogPageView:self.myTitle];
}

#pragma mark -- initial
/*
- (void)initialAudioPlayer
{
    NSString *pathMp3 = [[NSBundle mainBundle] pathForResource:@"skip" ofType:@"wav"];
    NSError *playerError  ;
    _avPlay = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:pathMp3] error:&playerError];
    _avPlay.volume = 0.045f ;   //0.015f
    if (_avPlay == nil) NSLog(@"Error creating player: %@", [playerError description]);
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil] ;
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [[SDImageCache sharedImageCache] clearMemory] ;
}

#pragma mark --
#pragma mark - Public


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
    else
    {
//        [self backButtonSet] ;
    }
}

- (void)setIsNetSuccess:(BOOL)isNetSuccess
{
    _isNetSuccess = isNetSuccess ;
    
    [self setBackgroundWithWifiSuccess:isNetSuccess] ;
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

- (void)setBackgroundWithWifiSuccess:(BOOL)bSuccess
{

    if (bSuccess)
    {
        [self.myTable setBackgroundView:nil] ;
    }
    else
    {
        UIView *nowifiView = [[[NSBundle mainBundle] loadNibNamed:@"NoWifiView" owner:self options:nil] lastObject] ;
        nowifiView.frame = self.myTable.frame ;
        [self.myTable setBackgroundView:nowifiView] ;
    }
    
    NSLog(@"self.myTable : %@ ",NSStringFromCGRect(self.myTable.frame)) ;
}

- (UIImageView *)guidingImageView
{
    if (!_guidingImageView) {
        _guidingImageView = [[UIImageView alloc] init] ;
        CGRect rectGuiding = APPFRAME ;
        rectGuiding.size.height = ( DEVICE_IS_IPHONE5 ) ? APPFRAME.size.height : APPFRAME.size.width / 9.0 * 16.0 ;
        _guidingImageView.frame = rectGuiding ;
        _guidingImageView.backgroundColor = nil ;
        _guidingImageView.userInteractionEnabled = YES ;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGuidingImageView)] ;
        [_guidingImageView addGestureRecognizer:tapGesture] ;
    }
    
    if (![_guidingImageView superview]) {
        [[UIApplication sharedApplication].keyWindow addSubview:_guidingImageView] ;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

