//
//  UEHeadPicCell.h
//  subao
//
//  Created by TuTu on 15/9/17.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UEHeadPicCellDelegate <NSObject>
- (void)clickHeadInEditUserInfoCtrller ;
@end

@interface UEHeadPicCell : UITableViewCell

@property (nonatomic,weak) id <UEHeadPicCellDelegate> delegate ;
@property (nonatomic,strong) UIImage *picHead ;

@end
