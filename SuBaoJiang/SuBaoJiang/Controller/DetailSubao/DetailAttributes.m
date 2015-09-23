//
//  DetailAttributes.m
//  subao
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "DetailAttributes.h"

@implementation DetailAttributes

+ (NSMutableParagraphStyle *)paragraphWithLineSpace:(CGFloat)lineSpace
{
    NSMutableParagraphStyle *_paragraph = [[NSMutableParagraphStyle alloc ] init] ;
    _paragraph.alignment = NSTextAlignmentLeft ;
    _paragraph.lineSpacing = lineSpace ;
    
    return _paragraph ;
}

+ (NSDictionary *)attributesWithLineSpace:(CGFloat)lineSpace
{
    NSDictionary *_attributes = @{
                        NSParagraphStyleAttributeName : [self paragraphWithLineSpace:lineSpace] ,
                        NSFontAttributeName : [UIFont systemFontOfSize:16.0]
                        } ;
    
    return _attributes ;
}

@end
