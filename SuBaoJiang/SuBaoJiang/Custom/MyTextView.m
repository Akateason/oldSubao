//
//  MyTextView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "MyTextView.h"
#import "ColorsHeader.h"



@implementation MyTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        
//        CGColorRef cgColor      = COLOR_LIGHT_GRAY.CGColor ;
        float      width        = 1.0f ;
//        self.layer.borderColor  = cgColor ;
        self.layer.borderWidth  = width ;
        self.layer.cornerRadius = CORNER_RADIUS_ALL  ;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.font = [UIFont systemFontOfSize:12.0f] ;
        
    }
    
    return self;
}


- (void)anyStyle
{
    self.layer.borderColor = COLOR_BACKGROUND.CGColor ;
    self.layer.borderWidth = 0.0f ;
    
    self.font              = [UIFont systemFontOfSize:12.0f] ;
}


@end
