//
//  PostShareCell.h
//  SuBaoJiang
//
//  Created by apple on 15/6/29.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PostShareCellDelegate <NSObject>
- (void)weiboPressed:(BOOL)bSelected ;
- (void)weixinPressed:(BOOL)bSelected ;
@end

@interface PostShareCell : UITableViewCell
@property (nonatomic,weak) id <PostShareCellDelegate> delegate ;
@end
