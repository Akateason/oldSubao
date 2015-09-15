//
//  SettingKVCell.h
//  SuBaoJiang
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingKVCell : UITableViewCell
@property (nonatomic)      BOOL canBeSelected   ;   // DEFAULT IS TRUE
@property (nonatomic,copy) NSString *key        ;
@property (nonatomic,copy) NSString *value      ;
@end
