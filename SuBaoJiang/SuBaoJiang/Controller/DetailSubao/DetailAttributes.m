//
//  DetailAttributes.m
//  subao
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "DetailAttributes.h"

@implementation DetailAttributes

+ (NSMutableParagraphStyle *)paragraph
{
    NSMutableParagraphStyle *_paragraph = [[NSMutableParagraphStyle alloc ] init] ;
    _paragraph.alignment = NSTextAlignmentLeft ;
    _paragraph.lineSpacing = 7.0 ;
    
    return _paragraph ;
}

+ (NSDictionary *)attributes
{
    NSDictionary *_attributes = @{
                        //NSForegroundColorAttributeName : textColor ,
                        NSParagraphStyleAttributeName : [self paragraph] ,
                        NSFontAttributeName : [UIFont systemFontOfSize:14]
                        } ;
    
    return _attributes ;
}

@end
