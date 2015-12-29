//
//  NavTitleView.m
//  SuBaoJiang
//
//  Created by apple on 15/6/2.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "NavTitleView.h"
#import "XTAnimation.h"

@interface NavTitleView ()
@property (nonatomic,strong) UILabel *label ;
@property (nonatomic,weak) IBOutlet UIImageView *titleImageView ;
@end

@implementation NavTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib] ;
    self.backgroundColor = nil ;
}

- (void)animate
{
//    CABasicAnimation *animate = [XTAnimation opacityTimes_Animation:1 durTimes:0.15] ;
//    [self.titleImageView.layer addAnimation:animate forKey:nil] ;
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr ;
    
    _titleImageView.hidden = YES ;
    self.label.text = [NSString stringWithFormat:@"#%@#",_titleStr] ;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero] ;
        _label.textColor = [UIColor whiteColor] ;
        _label.textAlignment = NSTextAlignmentCenter ;
        _label.font = [UIFont boldSystemFontOfSize:17.0] ;
        if (![_label superview]) {
            [self addSubview:_label] ;
        }
    }
    return _label ;
}

- (void)layoutSubviews
{
    [super layoutSubviews] ;
    
    CGRect rect = CGRectZero ;
    rect.origin = CGPointZero ;
    rect.size = self.frame.size ;
    [self.label sizeToFit] ;
    self.label.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) ;
}

@end
