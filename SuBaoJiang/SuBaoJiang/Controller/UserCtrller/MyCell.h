//
//  MyCell.h
//  SuBaoJiang
//
//  Created by apple on 15/7/11.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyCellDelegate <NSObject>
- (void)jump2Article:(int)a_id ;
- (void)clickDraft:(int)super_cid ;
@end

@interface MyCell : UITableViewCell
@property (nonatomic,strong) id <MyCellDelegate> delegate ;
@end
