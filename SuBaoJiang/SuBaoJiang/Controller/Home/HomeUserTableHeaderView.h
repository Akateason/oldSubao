//
//  HomeUserTableHeaderView.h
//  subao
//
//  Created by TuTu on 16/1/5.
//  Copyright © 2016年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Article ;

@protocol HomeUserTableHeaderViewDelegate <NSObject>

- (void)clickUserHead:(int)userID ;

@end

@interface HomeUserTableHeaderView : UITableViewHeaderFooterView

@property (nonatomic,weak) id <HomeUserTableHeaderViewDelegate> delegate ;
@property (nonatomic,strong) Article *article ;

@end
