//
//  SEMchooseCell.h
//  SuBaoJiang
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SEMchooseCellDelegate <NSObject>
/*
 * @param : buttonIndex 0-->速体验合计,1-->话题分类
 **/
- (void)clickChooseButtonIndex:(int)buttonIndex ;
@end

@interface SEMchooseCell : UITableViewCell

@property (nonatomic,weak) id <SEMchooseCellDelegate> delegate ;
- (void)animationForIcon ;
- (void)removeAnimation ;

@end
