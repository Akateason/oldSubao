//
//  KSBarrageView.m
//  KwSing
//
//  Created by yuchenghai on 14/12/22.
//  Copyright (c) 2014年 kuwo.cn. All rights reserved.
//

#import "KSBarrageView.h"
#import "UIView+Sizes.h"
#import "KSBarrageItemView.h"
#import "ArticleComment.h"
#import "HWWeakTimer.h"

#define ITEMTAG 1543

static const CGFloat speed_Max      = 150.0 ;
static const CGFloat speed_Min      = 100.0 ;
static const CGFloat seperateTime   = 0.3 ;
static const CGFloat basicSpeed     = 15.0 ;

@interface KSBarrageView ()
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation KSBarrageView
{
//    UIImageView *_avatarView;
//    UIImageView *_giftView;
    NSInteger    _curIndex;
}

- (void)dealloc
{
    [self stop] ;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setClipsToBounds:YES];
        _curIndex = 0;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self setClipsToBounds:YES];
        _curIndex = 0;
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    dataArray = [[dataArray reverseObjectEnumerator] allObjects] ;
    _dataArray = dataArray ;
}

- (void)start
{
    if (_dataArray && _dataArray.count > 0)
    {
        if (!_timer)
        {
            _timer = [HWWeakTimer scheduledTimerWithTimeInterval:seperateTime
                                                           block:^(id userInfo) {
                                                            [self postView] ;
            }
                                                        userInfo:@"Fire"
                                                         repeats:YES];
            [_timer fire] ;
        }
    }
}

- (void)stop
{
    [_timer invalidate];
}

- (void)postView
{
//    NSLog(@"barrage is on .") ;
    
    if (_dataArray && _dataArray.count > 0)
    {
        int indexPath = random()%(int)((self.frame.size.height) / 30);
        int top = indexPath * 30;
        
        UIView *view = [self viewWithTag:indexPath + ITEMTAG];
        if (view && [view isKindOfClass:[KSBarrageItemView class]]) return ;
        
        ArticleComment *cmt = nil;
        if (_dataArray.count > _curIndex)
        {
            cmt = _dataArray[_curIndex];
            _curIndex++;
        }
        else
        {
            _curIndex = 0;
            cmt = _dataArray[_curIndex];
            _curIndex++;
        }
        
        for (KSBarrageItemView *view in self.subviews)
        {
            if ([view isKindOfClass:[KSBarrageItemView class]] && view.itemIndex == _curIndex-1)
            {
                return ;
            }
        }
        
        KSBarrageItemView *item = [[KSBarrageItemView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width, top, 10, 40)] ;
        
        [item setFlywordWithComment:cmt] ;
        
        item.itemIndex = _curIndex - 1 ;
        item.tag = indexPath + ITEMTAG ;
        [self addSubview:item] ;
        
        NSUInteger lengthOfStr = [item.strWillShow length] ;
        CGFloat speed = basicSpeed * lengthOfStr ;
        speed = (speed > speed_Max) ? speed_Max : speed ;
        speed = (speed < speed_Min) ? speed_Min : speed ;
        
        CGFloat time = (item.width + [[UIScreen mainScreen] bounds].size.width) / speed ;
        
        [UIView animateWithDuration:time delay:0.0f
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                         animations:^{
                             item.left = - item.width;
                         }
                         completion:^(BOOL finished) {
                             [item removeFromSuperview];
        }];
        
    }
}

@end
