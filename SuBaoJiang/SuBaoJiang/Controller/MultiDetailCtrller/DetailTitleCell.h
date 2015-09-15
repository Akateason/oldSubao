//
//  DetailTitleCell.h
//  subao
//
//  Created by apple on 15/8/12.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Article ;

@interface DetailTitleCell : UITableViewCell
@property (nonatomic,strong) Article *article ;
+ (CGFloat)calculateHeight:(Article *)article ;
@end
