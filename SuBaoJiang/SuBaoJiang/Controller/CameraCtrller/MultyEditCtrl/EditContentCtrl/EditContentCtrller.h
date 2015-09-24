//
//  EditContentCtrller.h
//  subao
//
//  Created by apple on 15/8/20.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "RootCtrl.h"
@class Article ;

@protocol EditContentCtrllerDelegate <NSObject>
- (void)sendContentBack:(NSString *)content AndClient_aID:(int)client_aID ;
@end

@interface EditContentCtrller : RootCtrl
@property (nonatomic,weak)   id <EditContentCtrllerDelegate> delegate ;
@property (nonatomic,strong) Article *article ;
@property (nonatomic)        int     maxCount ;
@end
