//
//  SettingKVCell.m
//  SuBaoJiang
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "SettingKVCell.h"

@interface SettingKVCell ()

@property (weak, nonatomic) IBOutlet UILabel *lb_key;
@property (weak, nonatomic) IBOutlet UILabel *lb_val;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightSideFlex;

@end

@implementation SettingKVCell

- (void)setKey:(NSString *)key
{
    _key = key ;
    
    _lb_key.text = key ;
}

- (void)setValue:(NSString *)value
{
    _value = value ;
    
    _lb_val.hidden = [value length] ? NO : YES ;
    _lb_val.text = value ;
}

- (void)setCanBeSelected:(BOOL)canBeSelected
{
    _canBeSelected = canBeSelected ;
    
    _rightSideFlex.constant = canBeSelected ? 0.0 : 36.0 ;
    self.accessoryType = canBeSelected ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone ;
}
- (void)awakeFromNib {
    // Initialization code
    
    _lb_val.hidden = YES ;
    _canBeSelected = YES ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
