//
//  SuBaoHeaderView.h
//  SuBaoJiang
//
//  Created by apple on 15/6/2.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"


@protocol SuBaoHeaderViewDelegate <NSObject>
- (void)clickUserHead:(int)userID ;
@end


@interface SuBaoHeaderView : UIView
@property (nonatomic,retain) id <SuBaoHeaderViewDelegate> delegate ;
@property (nonatomic,strong) Article *article ;

@end
