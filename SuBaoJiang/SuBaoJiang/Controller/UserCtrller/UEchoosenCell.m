//
//  UEchoosenCell.m
//  subao
//
//  Created by TuTu on 15/9/17.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "UEchoosenCell.h"

@interface UEchoosenCell ()
@property (weak, nonatomic) IBOutlet UILabel *lb_show;
@end

@implementation UEchoosenCell

- (void)awakeFromNib
{
    // Initialization code
    
}

- (void)setStrShow:(NSString *)strShow
{
    _strShow = strShow ;
    
    self.lb_show.text = strShow ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
