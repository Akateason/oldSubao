//
//  PointButton.h
//  SuBaoJiang
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTPointButton : UIButton

@property (nonatomic) BOOL isMarked ;
@property (nonatomic,strong) UIView *pointV ;

- (void)pointViewPosition ;

@end
