//
//  LogoAboutCell.m
//  SuBaoJiang
//
//  Created by apple on 15/7/1.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "LogoAboutCell.h"
#import "XTAnimation.h"

@implementation LogoAboutCell

- (void)awakeFromNib
{
    // Initialization code
    
    self.backgroundColor = COLOR_BACKGROUND ;
    _img_logo.layer.cornerRadius = CORNER_RADIUS_ALL ;
    _img_logo.layer.masksToBounds = YES ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state    
    
    [XTAnimation animationRippleEffect:_img_logo] ;
}

@end
