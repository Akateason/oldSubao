//
//  PasterCtrller.h
//  subao
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "RootCtrl.h"
#import <PhotoEditFramework/PhotoEditFramework.h>

@protocol PasterCtrllerDelegate <NSObject>
- (void)pasterAddFinished:(UIImage *)imageFinished ;
@end

@interface PasterCtrller : RootCtrl

@property (nonatomic,weak)   id <PasterCtrllerDelegate> delegate ;
@property (nonatomic,strong) UIImage *imageWillHandle ;

@end
