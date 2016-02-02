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
{
    NSUInteger lastSelectedIndex ;
}
@end

@implementation MyTabbarCtrller

static int indexCache = 0 ;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        // Set in AppDelegate
        ((AppDelegate *)[UIApplication sharedApplication].delegate).tabbarCtrller = self ;
        
        self.tabBar.tintColor = COLOR_MAIN ;
        self.delegate = self ;
    }
    return self ;
}

#pragma mark --
#pragma mark - tabbar controller delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([tabBarController.selectedViewController isEqual:viewController])
    {
        //double tap item in index page .
        if ([viewController isMemberOfClass:[NavIndexCtrller class]])
        {
            indexCache ++ ;
            [self performSelectorInBackground:@selector(deleteCacheIndex) withObject:nil] ;
            if (indexCache % 2 == 0) [self.homePageDelegate doubleTapedHomePage] ;
        }
        else
        {
            indexCache = 0 ;
        }
        return NO ;
    }
    return YES ;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"did selectedIndex %@",@(tabBarController.selectedIndex)) ;

//  1. to camera .
    if (tabBarController.selectedIndex == 2) {
        [NavCameraCtrller jump2NavCameraCtrllerWithOriginCtrller:self.selectedViewController] ;
        tabBarController.selectedIndex = lastSelectedIndex ;
    }
    lastSelectedIndex = tabBarController.selectedIndex ;
    
//  2. animation
    [self clickItemAnimation:tabBarController] ;
}

static float kScaleSize = 1.35 ;
- (void)clickItemAnimation:(UITabBarController *)tabBarController
{
    NSMutableArray *arrayBt = [@[] mutableCopy] ;
    for (id tabBt in [tabBarController.tabBar subviews])
        if ([tabBt isKindOfClass:NSClassFromString(@"UITabBarButton")])
            [arrayBt addObject:tabBt] ;
    
    NSArray *resultList = [arrayBt sortedArrayWithOptions:0
                                          usingComparator:^NSComparisonResult(UIView *obj1, UIView *obj2) {
                                              NSComparisonResult result = [@(obj1.frame.origin.x) compare:@(obj2.frame.origin.x)] ;
                                              return result == NSOrderedDescending ;
                                          }] ;
//    NSLog(@"resultList  : %@",resultList) ;
    
    UIView *selectedView = [resultList objectAtIndex:tabBarController.selectedIndex] ;
    int i = 0 ;
//    NSLog(@"[view subviews] : %@",[selectedView subviews]) ;
    
    for (id tmp in [selectedView subviews]) {
        if ([tmp isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) break ;
        i++ ;
    }
    
    UIView *viewWillanimate = [[selectedView subviews]objectAtIndex:i] ;
    viewWillanimate.transform = CGAffineTransformScale(viewWillanimate.transform, kScaleSize, kScaleSize) ;
    
    [UIView animateWithDuration:1.
                          delay:0
         usingSpringWithDamping:0.4
          initialSpringVelocity:5.
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                         viewWillanimate.transform = CGAffineTransformIdentity ;
                         
                     } completion:^(BOOL finished) {
                         
                     }] ;

}


- (void)deleteCacheIndex
{
    sleep(1) ;
    indexCache = 0 ;
}


@end
