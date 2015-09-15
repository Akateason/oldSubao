//
//  NSString+HMac_SHA1.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-23.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "NSString+HMac_SHA1.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>


@implementation NSString (HMac_SHA1)



+ (NSString *) hmacSha1:(NSString*)key text:(NSString*)text
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    //NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    NSString *hash;
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    [output appendFormat:@"%02x", cHMAC[i]];
    hash = output;
    
    return hash;
}


@end
