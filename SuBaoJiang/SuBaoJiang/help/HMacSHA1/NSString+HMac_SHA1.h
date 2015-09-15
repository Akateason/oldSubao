//
//  NSString+HMac_SHA1.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-23.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HMac_SHA1)

+ (NSString *) hmacSha1:(NSString*)key text:(NSString*)text ;

@end
