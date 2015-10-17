//
//  ScrollPageView.h
//  Teason
//
//  Created by ; on 14-8-21.
//  Copyright (c) 2014年 TEASON. All rights reserved.
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
    BOOL mNeedUseDelegate    ;
}

@property (nonatomic,retain) UIScrollView   *scrollView;
@property (nonatomic,retain) NSMutableArray *contentItems;
@property (nonatomic,weak) id<ScrollPageViewDelegate> delegate;

@property (nonatomic) NSInteger mCurrentPage ;

- (void)setContentOfTables:(NSInteger)aNumerOfTables;
- (void)moveScrollowViewAthIndex:(NSInteger)aIndex;
- (UIScrollView *)freshContentTableAtIndex:(NSInteger)aIndex ;
- (void)updateAlreadyWithIndex:(NSInteger)index ;

@end
