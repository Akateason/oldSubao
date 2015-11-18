//
//  NSDate+Addition.m
//  SuBaoJiang
//
//  Created by apple on 15/6/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "NSDate+Addition.h"

@implementation NSDate (Addition)


- (NSDateComponents *)shareComps
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    
    return comps;
}

- (int)getYear
{
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ;
//    comps = [calendar components:unitFlags fromDate:self];

    NSDateComponents *comps = [self shareComps];
    
    return [comps year];
}

- (int)getMonth
{
    NSDateComponents *comps = [self shareComps];
    
    return [comps month];
}

- (int)getDay
{
    NSDateComponents *comps = [self shareComps];
    
    return [comps day];
}


+ (int)daysInMonth:(int)imonth year:(int)year
{
    if((imonth == 1)||(imonth == 3)||(imonth == 5)||(imonth == 7)||(imonth == 8)||(imonth == 10)||(imonth == 12))
        return 31;
    if((imonth == 4)||(imonth == 6)||(imonth == 9)||(imonth == 11))
        return 30;
    if((year%4 == 1)||(year%4 == 2)||(year%4 == 3))
    {
        return 28;
    }
    if(year%400 == 0)
        return 29;
    if(year%100 == 0)
        return 28;
    return 29;
}

@end
