//
//  MyCmtCell.h
//  SuBaoJiang
//
//  Created by apple on 15/6/16.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleComment.h"
#import "Msg.h"
#import "NotificationCenterHeader.h"

@interface MyCmtCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *bt_head;

@property (nonatomic,strong) ArticleComment *cmt ;
@property (nonatomic,strong) Msg            *msg ;
@property (nonatomic)        BOOL           bNoteCmt ;

+ (CGFloat)calculateHeightWithCmt:(NSString *)content ;

+ (CGFloat)calculateTableSumHeightWith:(NSMutableArray *)list ;

@end
