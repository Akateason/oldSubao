//
//  MyCommentsCell.h
//  SuBaoJiang
//
//  Created by apple on 15/6/16.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCell.h"
@interface MyCommentsCell : MyCell <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *cmtList ;
@end
