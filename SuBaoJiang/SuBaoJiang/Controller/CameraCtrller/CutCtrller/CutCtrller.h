//
//  CutCtrller.h
//  subao
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "RootCtrl.h"

@protocol CutCtrllerDelegate <NSObject>
- (void)cuttingFinished:(UIImage *)imageFinished ;
@end

@interface CutCtrller : RootCtrl
@property (nonatomic,strong) id <CutCtrllerDelegate> delegate ;
@property (nonatomic,strong) UIImage *imgBringIn ;
@property (nonatomic,strong) UIImage *whiteSideImg ;
@end
