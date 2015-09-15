//
//  TeaCornerView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-29.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "XTCornerView.h"

@implementation XTCornerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+ (void)setRoundHeadPicWithView:(UIView*)v
{
    float height = v.frame.size.height / 2.0f ;
    
    [v.layer setCornerRadius:height];
    
    v.contentMode = UIViewContentModeScaleToFill ;
    v.layer.masksToBounds = YES;
}



@end
