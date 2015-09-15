//
//  HorizonTable.h
//  subao
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HorizonTableDelegate <NSObject>
- (void)scrolledFinish:(NSInteger)index ;
@end

@interface HorizonTable : UITableView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) id <HorizonTableDelegate> myDelegate ;
@property (nonatomic)        NSInteger  currentIndex ;

- (instancetype)initWithFrame:(CGRect)frame
              andWithDataList:(NSArray *)list ;
@end
