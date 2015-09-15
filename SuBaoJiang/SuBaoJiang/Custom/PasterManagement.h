//
//  PasterManagement.h
//  subao
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Paster.h"

@interface PasterManagement : NSObject
+ (PasterManagement *)shareInstance ;
@property (nonatomic,copy) NSArray *allPastersList ;
@end
