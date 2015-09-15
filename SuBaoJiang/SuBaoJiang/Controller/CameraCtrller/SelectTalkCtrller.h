//
//  SelectTalkCtrller.h
//  SuBaoJiang
//
//  Created by apple on 15/6/26.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "RootCtrl.h"

@protocol SelectTalkCtrllerDelegate <NSObject>
- (void)talkContentSelected:(NSString *)topicContent ;
@end

@interface SelectTalkCtrller : RootCtrl
@property (nonatomic,retain) id <SelectTalkCtrllerDelegate> delegate ;
@end
