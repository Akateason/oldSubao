//
//  MySubaoCell.h
//  SuBaoJiang
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCell.h"

@interface MySubaoCell : MyCell

@property (nonatomic,copy) NSArray *subaoList ;

+ (CGFloat)calculateHeightWithList:(NSArray *)list ;

@end
