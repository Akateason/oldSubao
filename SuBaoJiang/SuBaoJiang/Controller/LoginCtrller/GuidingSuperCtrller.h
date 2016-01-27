//
//  GuidingSuperCtrller.h
//  subao
//
//  Created by TuTu on 16/1/27.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "RootCtrl.h"

@interface GuidingSuperCtrller : RootCtrl

@property (nonatomic,strong) UIView *headTitle ;
@property (nonatomic,strong) UIView *mainContents ;
@property (nonatomic,strong) UIView *tailTitle ;

- (void)startingAnimation ;

@end
