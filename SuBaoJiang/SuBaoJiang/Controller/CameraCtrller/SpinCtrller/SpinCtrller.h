//
//  SpinCtrller.h
//  subao
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "RootCtrl.h"

@protocol SpinCtrllerDelegate <NSObject>
- (void)spinFinished:(UIImage *)imageFinished ;
@end

@interface SpinCtrller : RootCtrl
@property (nonatomic,weak)   id <SpinCtrllerDelegate> delegate ;
@property (nonatomic,strong) UIImage *imgBringIn ;
@end
