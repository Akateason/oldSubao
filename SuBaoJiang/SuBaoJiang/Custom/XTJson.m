//
//  XTJson.m
//  subao
//
//  Created by TuTu on 16/1/7.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "XTJson.h"

@implementation XTJson

+ (id)getJsonObj:(NSString *)jsonStr
{
    NSError *error ;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]
                                                 options:kNilOptions
                                                   error:&error] ;
    if (!jsonObj)
    {
        NSLog(@"json parse FAILED : %@",error) ;
        return nil ;
    }
    
    return jsonObj ;
}

+ (NSString *)getJsonStr:(id)jsonObj
{
    NSString *jsonStr ;
    
    if ([NSJSONSerialization isValidJSONObject:jsonObj])
    {
        NSError *error ;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObj
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error] ;
        jsonStr = [[NSString alloc] initWithData:jsonData
                                        encoding:NSUTF8StringEncoding] ;
        NSLog(@"jsonStr : %@",jsonStr) ;
    }
    else
    {
        NSLog(@"IS NOT KIND OF JSON OBJECT") ;
    }

    return jsonStr ;
}

@end
