//
//  PasterView.h
//  Paster
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasterStageView.h"
@class PasterView ;

@protocol PasterViewDelegate <NSObject>
- (void)makePasterBecomeFirstRespond:(int)pasterID ;
- (void)removePaster:(int)pasterID ;
@end

@interface PasterView : UIView
@property (nonatomic,strong)    UIImage *imagePaster ;
@property (nonatomic)           int     pasterID ;
@property (nonatomic)           BOOL    isOnFirst ;
@property (nonatomic,strong)    id <PasterViewDelegate> delegate ;
- (instancetype)initWithBgView:(PasterStageView *)bgView
                      pasterID:(int)pasterID
                           img:(UIImage *)img ;
- (void)remove ;
@end
