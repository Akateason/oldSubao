//
//  DetailAttributes.h
//  subao
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailAttributes : NSObject

+ (NSMutableParagraphStyle *)paragraphWithLineSpace:(CGFloat)lineSpace ;

+ (NSDictionary *)attributesWithLineSpace:(CGFloat)lineSpace ;

@end
