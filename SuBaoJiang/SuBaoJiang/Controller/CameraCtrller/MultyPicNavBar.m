//
//  MultyPicNavBar.m
//  subao
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "MultyPicNavBar.h"

@interface MultyPicNavBar ()
@property (nonatomic,strong) UIButton *btBack ;
@property (nonatomic,strong) UIButton *btSelect ;
@end

@implementation MultyPicNavBar

#pragma mark --
#pragma mark - Initial
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self btBack] ;
        [self btSelect] ;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6] ;
    }
    
    return self;
}

#pragma mark --
#pragma mark - Property
- (void)setIsChoosen:(BOOL)isChoosen
{
    _isChoosen = isChoosen ;
    
    self.btSelect.selected = isChoosen ;
}

- (UIButton *)btBack
{
    if (!_btBack)
    {
        _btBack = [[UIButton alloc] init] ;
        [_btBack setImage:[UIImage imageNamed:@"backBt"]
                 forState:UIControlStateNormal] ;
        
        _btBack.frame = CGRectMake(5, 17, 30, 30) ;
        [_btBack addTarget:self
                    action:@selector(backBtClickedAction)
          forControlEvents:UIControlEventTouchUpInside] ;
        
        if (![_btBack superview])
        {
            [self addSubview:_btBack] ;
        }
    }
    
    return _btBack ;
}

- (UIButton *)btSelect
{
    if (!_btSelect)
    {
        _btSelect = [[UIButton alloc] init] ;
        [_btSelect setImage:[UIImage imageNamed:@"camera_picSelect_On"]
                 forState:UIControlStateSelected] ;
        [_btSelect setImage:[UIImage imageNamed:@"camera_picSelect_Off"]
                 forState:UIControlStateNormal] ;
        _btSelect.selected = YES ;
        _btSelect.frame = CGRectMake(self.frame.size.width - 30 - 10, 17, 30, 30) ;
        [_btSelect addTarget:self
                      action:@selector(selectBtClickedAction)
            forControlEvents:UIControlEventTouchUpInside] ;
        
        if (![_btSelect superview])
        {
            [self addSubview:_btSelect] ;
        }
    }
    
    return _btSelect ;
}

#pragma mark --
#pragma mark - Action
- (void)backBtClickedAction
{
    [self.delegate popBack] ;
}

- (void)selectBtClickedAction
{
    self.btSelect.selected = !self.btSelect.selected ;
    [self.delegate selectPressed:self.btSelect.selected] ;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
