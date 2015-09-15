//
//  MultyPicNavBar.h
//  subao
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MultyPicNavBarDelegate <NSObject>
- (void)popBack ;
- (void)selectPressed:(BOOL)choosen ;
@end

@interface MultyPicNavBar : UIView
@property (nonatomic)   BOOL isChoosen ;
@property (nonatomic,strong) id <MultyPicNavBarDelegate> delegate ;
@end
