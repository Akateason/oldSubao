//
//  MyTabbarCtrller.h
//  SuBaoJiang
//
//  Created by apple on 15/6/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyTabbarCtrllerDelegate <NSObject>
- (void)doubleTapedHomePage ;
@end

@interface MyTabbarCtrller : UITabBarController <UITabBarControllerDelegate>
@property (nonatomic,strong) id <MyTabbarCtrllerDelegate> homePageDelegate ;
@end
