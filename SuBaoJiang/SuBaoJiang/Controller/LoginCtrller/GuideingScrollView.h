//
//  GuideingScrollView.h
//  SuBaoJiang
//
//  Created by apple on 15/7/1.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GuideingScrollViewDelegate <NSObject>
@optional
- (void)logSelf ;
- (void)seeMore ;
@end

@interface GuideingScrollView : UIScrollView

@property (nonatomic, weak)     id <GuideingScrollViewDelegate> guidingDelegate ;
@property (nonatomic)           BOOL                            isAboutUS ;
@property (nonatomic, strong)   UIViewController                *currentCtrller ;

@end
