//
//  Paster.h
//  subao
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Paster : NSObject
@property (nonatomic,copy) NSString *name ;
@property (nonatomic,copy) NSString *url ;
- (instancetype)initWithDic:(NSDictionary *)dic ;
@end
