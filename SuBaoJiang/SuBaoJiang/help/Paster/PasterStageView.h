//
//  BackgroundView.h
//  Paster
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasterStageView : UIView
@property (nonatomic,strong) UIImage *originImage ;
- (instancetype)initWithFrame:(CGRect)frame ;
- (void)addPasterWithImg:(UIImage *)imgP ;
- (UIImage *)doneEdit ;
@end
