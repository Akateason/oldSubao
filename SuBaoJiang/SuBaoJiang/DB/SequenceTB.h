//
//  SequenceTB.h
//  subao
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "DigitInformation.h"

@interface SequenceTB : NSObject
+ (SequenceTB *)shareInstance ;
- (BOOL)creatTable ;
- (int)getMaxID ;
- (BOOL)insertSequece:(NSString *)strOfList OfSuper_Cid:(int)cid ;
- (BOOL)updateSequece:(NSString *)strOfList OfSuper_Cid:(int)cid ;
- (NSString *)getSequeceStrWithCid:(int)cid ;
- (BOOL)ExistThisSequece:(int)superCid ;
@end
