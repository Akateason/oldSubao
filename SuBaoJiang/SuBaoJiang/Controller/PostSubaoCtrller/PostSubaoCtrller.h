//
//  PostSubaoCtrller.h
//  SuBaoJiang
//
//  Created by apple on 15/6/26.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "RootCtrl.h"
#import "NotificationCenterHeader.h"

@interface PostSubaoCtrller : RootCtrl <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy)             NSString    *topicString ; // can be nil ;
@property (nonatomic, retain)           UIImage     *imageSend ; // NN
@property (weak, nonatomic) IBOutlet    UITableView *table ;
- (void)shareArticleNow ;

@end
