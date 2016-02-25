//
//  GuidingSuperCtrller.h
//  subao
//
//  Created by TuTu on 16/1/27.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "RootCtrl.h"

@interface GuidingSuperCtrller : RootCtrl

@property (nonatomic,weak) UIView *headTitle ;
@property (nonatomic,weak) UIView *mainContents ;
@property (nonatomic,weak) UIView *tailTitle ;

- (void)startingAnimation ;

@end
