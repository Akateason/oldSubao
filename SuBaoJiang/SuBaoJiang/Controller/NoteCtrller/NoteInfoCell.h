//
//  NoteInfoCell.h
//  subao
//
//  Created by apple on 15/8/3.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Msg ;

@interface NoteInfoCell : UITableViewCell
@property (nonatomic,strong) Msg *msg ;
+ (CGFloat)calculateHeightWithMsg:(Msg *)msg ;
@end
