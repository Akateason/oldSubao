//
//  MyTabbarCtrller.m
//  SuBaoJiang
//
//  Created by apple on 15/6/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "MyTabbarCtrller.h"
#import "NavIndexCtrller.h"
#import "NavCameraCtrller.h"
#import "AppDelegate.h"

@interface MyTabbarCtrller ()

@end

@implementation MyTabbarCtrller

static int indexCache = 0 ;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
        
        ((AppDelegate *)[UIApplication sharedApplication].delegate).tabbarCtrller = self ; // set in AppDelegate
        
        self.tabBar.tintColor = COLOR_MAIN ;
        self.delegate = self ;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad] ;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewController isMemberOfClass:[NavCameraCtrller class]])
    {
//        NSLog(@"camera clicked !") ;
        [NavCameraCtrller jump2NavCameraCtrllerWithOriginCtrller:self.selectedViewController] ;
        return NO ;
    }
    
    if ([tabBarController.selectedViewController isEqual:viewController])
    {
        //double tap item in index page .
        if ([viewController isMemberOfClass:[NavIndexCtrller class]])
        {
            indexCache ++ ;
            
            [self performSelectorInBackground:@selector(deleteCacheIndex)
                                   withObject:nil] ;
            
            if (indexCache % 2 == 0)
            {
                [self.homePageDelegate doubleTapedHomePage] ;
            }
        }
        else
        {
            indexCache = 0 ;
        }
        return NO;
    }
    
    return YES;
}


- (void)deleteCacheIndex
{
    sleep(1) ;
    indexCache = 0 ;
}

@end
