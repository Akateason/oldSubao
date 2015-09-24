//
//  TeaSegment.h
//  TeaSegment
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTPointButton.h"


@protocol TeaSegmentDelegate <NSObject>
- (void)clickSegmentWith:(int)index ;
@end

@interface XTSegment : UIView

@property (nonatomic,weak)   id <TeaSegmentDelegate> delegate ;
@property (nonatomic)        int     currentIndex ;
@property (nonatomic,strong) NSArray *dataList ;
@property (nonatomic,strong) UIImage *imgBG_sel ;
@property (nonatomic,strong) UIColor *normalColor ;
@property (nonatomic,strong) UIColor *selectColor ;
@property (nonatomic)        CGFloat heightForSeg ;
@property (nonatomic,strong) UIFont  *font ;

- (instancetype)initWithDataList:(NSArray *)datalist
                           imgBg:(UIImage *)imgBg
                          height:(CGFloat)height
                     normalColor:(UIColor *)normalColor
                     selectColor:(UIColor *)selectColor
                            font:(UIFont *)font ;

- (void)moveToIndex:(int)index
           callBack:(BOOL)callback ;

- (void)makeBadgesForSegmentsWithBadgeList:(NSArray *)badgeList ;

@end
