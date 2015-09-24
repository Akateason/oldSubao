//
//  ThirdLoginCtrller.h
//  SuBaoJiang
//
//  Created by apple on 15/6/18.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "RootCtrl.h"


@protocol ThirdLoginCtrllerDelegate <NSObject>

@optional
- (void)logSelf ;
- (void)seeMore ;

@end


@interface ThirdLoginCtrller : RootCtrl

//ADDITION
@property (nonatomic)   BOOL    bAboutUs ; // DEFAULT IS NO;
@property (nonatomic,weak) id <ThirdLoginCtrllerDelegate> delegate ;

@property (nonatomic)   BOOL    bLaunchInNav ;
- (void)startAnimate ;

@end
