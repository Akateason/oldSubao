//
//  UEchoosenCell.m
//  subao
//
//  Created by TuTu on 15/9/17.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "UEKeyValCell.h"

@interface UEKeyValCell ()
@property (weak, nonatomic) IBOutlet UILabel *lb_key;
@property (weak, nonatomic) IBOutlet UILabel *lb_val;
@end

@implementation UEKeyValCell

- (void)awakeFromNib
{
    // Initialization code
    _lb_key.text = self.strKey ;
    _lb_val.text = self.strVal ;
}

- (void)setStrKey:(NSString *)strKey
{
    _strKey = strKey ;
    
    _lb_key.text = strKey ;
}

- (void)setStrVal:(NSString *)strVal
{
    _strVal = strVal ;
    
    _lb_val.text = strVal ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
