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
{
    UILabel *label ;
}
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
    
    CGRect rect = CGRectZero ;
    rect.origin = CGPointMake(0, 0) ;
    rect.size = self.frame.size ;
    
    label = [[UILabel alloc] initWithFrame:rect] ;
    label.textColor = [UIColor whiteColor] ;
    label.text = [NSString stringWithFormat:@"#%@#",_titleStr] ;
    label.textAlignment = NSTextAlignmentCenter ;
    label.font = [UIFont boldSystemFontOfSize:17.0] ;
    [label sizeToFit] ;
    label.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) ;
    if (![label superview]) {
        [self addSubview:label] ;
    }
    
}

@end
