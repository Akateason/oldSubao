//
//  ScrollPageView.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-20.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollPageViewDelegate <NSObject>

@optional
- (void)terminateApp ;
- (void)clearTopSegForPrepageIndex:(int)prepage ;
@required
- (void)didScrollPageViewChangedPage:(NSInteger)aPage;

@end



@interface ScrollPageView : UIView<UIScrollViewDelegate>
{
    BOOL        mNeedUseDelegate    ;
}

@property (nonatomic,retain) UIScrollView   *scrollView;
@property (nonatomic,retain) NSMutableArray *contentItems;
@property (nonatomic,assign) id<ScrollPageViewDelegate> delegate;

@property (nonatomic) NSInteger mCurrentPage ;

- (void)setContentOfTables:(NSInteger)aNumerOfTables;
- (void)moveScrollowViewAthIndex:(NSInteger)aIndex;
- (UIScrollView *)freshContentTableAtIndex:(NSInteger)aIndex ;
- (void)updateAlreadyWithIndex:(NSInteger)index ;

@end
