//
//  MultyPicChooseBar.m
//  subao
//
//  Created by apple on 15/8/18.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "MultyPicChooseBar.h"
#import "XTCornerView.h"

static const CGFloat sideFlex  = 8.0f ;
static const CGFloat btWidth   = 46.0f ;
static const CGFloat btHeight  = 30.0f ;
static const CGFloat lbSide    = 26.0f ;


@interface MultyPicChooseBar ()
@property (strong, nonatomic) UILabel *lb_chooseCount ;
@property (nonatomic, strong) UIButton *btPreview ;
@property (nonatomic, strong) UIButton *btFinish ;
@end

@implementation MultyPicChooseBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self lb_chooseCount] ;
        [self btPreview] ;
        [self btFinish] ;
        self.backgroundColor = COLOR_BACKGROUND ; // default bg ;
    }
    
    return self;
}

- (void)previewStyle
{
    self.btPreview.hidden = YES ;
    [self.btFinish setTitleColor:COLOR_MAIN forState:0] ;
}

#pragma mark - Property
- (UILabel *)lb_chooseCount
{
    if (!_lb_chooseCount)
    {
        _lb_chooseCount = [[UILabel alloc] init] ;
        CGRect rect = CGRectMake(0, 10, lbSide, lbSide) ;
        rect.origin.x = self.frame.size.width - sideFlex - btWidth - lbSide - 1 ;
        _lb_chooseCount.frame = rect ;
        _lb_chooseCount.text = @"0" ;
        _lb_chooseCount.textColor = [UIColor whiteColor] ;
        _lb_chooseCount.font = [UIFont systemFontOfSize:15.0f] ;
        _lb_chooseCount.textAlignment = NSTextAlignmentCenter ;
        _lb_chooseCount.backgroundColor = COLOR_MAIN ;
        [XTCornerView setRoundHeadPicWithView:_lb_chooseCount] ;
        if (![_lb_chooseCount superview])
        {
            [self addSubview:_lb_chooseCount] ;
        }
    }
    
    return _lb_chooseCount ;
}

- (UIButton *)btPreview
{
    if (!_btPreview)
    {
        _btPreview = [[UIButton alloc] init] ;
        [_btPreview setTitle:@"预览" forState:0] ;
        [_btPreview setTitleColor:COLOR_BLACK_DARK forState:0] ;
        [_btPreview.titleLabel setFont:[UIFont systemFontOfSize:17.0]] ;
        _btPreview.frame = CGRectMake(sideFlex, sideFlex, btWidth, btHeight) ;
        [_btPreview addTarget:self action:@selector(previewBtClickedAction) forControlEvents:UIControlEventTouchUpInside] ;
        if (![_btPreview superview])
        {
            [self addSubview:_btPreview] ;
        }
    }
    
    return _btPreview ;
}

- (UIButton *)btFinish
{
    if (!_btFinish)
    {
        _btFinish = [[UIButton alloc] init] ;
        [_btFinish setTitle:@"完成" forState:0] ;
        [_btFinish setTitleColor:COLOR_BLACK_DARK forState:0] ;
        [_btFinish.titleLabel setFont:[UIFont systemFontOfSize:17.0]] ;
        _btFinish.frame = CGRectMake(self.frame.size.width - sideFlex - btWidth , sideFlex, btWidth, btHeight) ;
        [_btFinish addTarget:self action:@selector(finishBtClickedAction) forControlEvents:UIControlEventTouchUpInside] ;
        if (![_btFinish superview])
        {
            [self addSubview:_btFinish] ;
        }
    }
    
    return _btFinish ;
}


#pragma mark - Action
- (void)finishBtClickedAction
{
    NSLog(@"完成") ;
    [self.delegate finishBtClicked] ;
}

- (void)previewBtClickedAction
{
    NSLog(@"预览") ;
    [self.delegate previewBtClicked] ;
}

- (void)setCount:(NSInteger)count
{
    _count = count ;
    
    _lb_chooseCount.text = [NSString stringWithFormat:@"%li",(long)count] ;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
