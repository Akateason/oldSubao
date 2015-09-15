//
//  VerticalArrangeButton.m
//  subao
//
//  Created by apple on 15/8/6.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "VerticalArrangeButton.h"

@implementation VerticalArrangeButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgHeight = 44.0f ;
    
    // Center image
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width / 2;
//    center.y = self.imageView.frame.size.height / 2 + 20.0;
    center.y = imgHeight / 2 + 20.0;

    self.imageView.center = center;
    
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
//    newFrame.origin.y = self.imageView.frame.size.height + 14.0 + 20.0;
    newFrame.origin.y = imgHeight + 14.0 + 20.0;

    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = UITextAlignmentCenter;
}


@end
