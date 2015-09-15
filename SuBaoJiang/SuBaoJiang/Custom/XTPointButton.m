//
//  PointButton.m
//  SuBaoJiang
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "XTPointButton.h"
#import "XTCornerView.h"

@interface XTPointButton ()
@end

@implementation XTPointButton

- (UIView *)pointV
{
    if (!_pointV)
    {
        _pointV = [[UIView alloc] init] ;
        
        if (![_pointV superview])
        {
            [self addSubview:_pointV] ;
        }
    }
    
    return _pointV ;
}

- (void)setIsMarked:(BOOL)isMarked
{
    _isMarked = isMarked ;
    
    self.pointV.hidden = !isMarked ;
}


- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected] ;
    
    self.pointV.alpha = selected ? 1.0 : 0.5 ;

}

#pragma mark -- public

- (void)setup
{
    CGRect rect = CGRectZero ;
    self.pointV.frame = rect ;
    self.pointV.backgroundColor = [UIColor redColor] ;
    
    _pointV.layer.borderColor = [UIColor whiteColor].CGColor ;
    _pointV.layer.borderWidth = 1.0f ;
}


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setup] ;
        self.isMarked = NO ;
    }
    return self;
}

- (void)pointViewPosition
{
    CGRect rect = CGRectZero ;
    rect.origin.x = self.frame.size.width / 2 + [self.titleLabel.text length] * 12 / 2 + 5 ;
    rect.origin.y = 10 ;
    rect.size = CGSizeMake(6, 6) ;
    _pointV.frame = rect ;
    
    [XTCornerView setRoundHeadPicWithView:_pointV] ;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
