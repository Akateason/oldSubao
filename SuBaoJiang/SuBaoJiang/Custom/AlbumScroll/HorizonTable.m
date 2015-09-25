//
//  HorizonTable.m
//  subao
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "HorizonTable.h"
#import "ReuseCellContent.h"
#import "HorizonCell.h"

@interface HorizonTable ()
@property (nonatomic,copy) NSArray *dataList ;
@end

@implementation HorizonTable

- (instancetype)initWithFrame:(CGRect)frame
              andWithDataList:(NSArray *)list
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.transform = CGAffineTransformMakeRotation(-M_PI_2);
        self.frame = frame ;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.separatorStyle = UITableViewCellSeparatorStyleNone ;
        self.separatorColor = COLOR_IMG_EDITOR_BG ;
        self.backgroundColor = COLOR_IMG_EDITOR_BG ;
        self.delegate = self ;
        self.dataSource = self ;
        self.dataList = list ;
        self.currentIndex = 0 ;
    }
    return self;
}


#pragma mark - UITableViewDataSource methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size.width ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"HorizonCell";
    HorizonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell)
    {
        cell = [[HorizonCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentify] ;
        cell.frame = self.frame ;
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    cell.dataObject = self.dataList[indexPath.row] ;
    
    return cell ;
}

#pragma mark --
#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentIndex = ( scrollView.contentOffset.y / self.frame.size.width );
    NSLog(@"self.currentIndex : %@",@(self.currentIndex)) ;
    [self.myDelegate scrolledFinish:self.currentIndex] ;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
