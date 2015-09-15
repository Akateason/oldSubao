//
//  RFSegmentView.h
//  RFSegmentView
//
//  Created by 王若风 on 1/15/15.
//  Copyright (c) 2015 王若风. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB_Color(r,g,b)    RGBA_Color(r,g,b,1)
#define RGBA_Color(r,g,b,a) ([UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:a])
#define kDefaultTintColor   RGB_Color(3, 116, 255)
#define kLeftMargin         15
#define kItemHeight         30
#define kBorderLineWidth    0.5
@class RFSegmentItem;
@protocol RFSegmentItemDelegate
- (void)ItemStateChanged:(RFSegmentItem *)item index:(NSInteger)index isSelected:(BOOL)isSelected;
@end

@interface RFSegmentItem : UIView
@property(nonatomic ,strong) UIColor *norColor;
@property(nonatomic ,strong) UIColor *selColor;
@property(nonatomic ,strong) UILabel *titleLabel;
@property(nonatomic)         NSInteger index;
@property(nonatomic)         BOOL isSelected;
@property(nonatomic)         id   delegate;

- (void)iPressedItem ;

@end





@protocol RFSegmentViewDelegate <NSObject>
- (void)segmentViewSelectIndex:(NSInteger)index;
@end

@interface RFSegmentView : UIView
/**
 *  设置风格颜色 默认蓝色风格
 */
@property(nonatomic ,strong) UIColor *tintColor;
@property(nonatomic) id<RFSegmentViewDelegate> delegate;

@property (nonatomic) int currentIndex ;
/**
 *  默认构造函数
 *
 *  @param frame frame
 *  @param items title字符串数组
 *
 *  @return 当前实例
 */
- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;

@end
