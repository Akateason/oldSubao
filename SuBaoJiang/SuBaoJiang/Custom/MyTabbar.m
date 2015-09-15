//
//  MyTabbar.m
//  SuBaoJiang
//
//  Created by apple on 15/6/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "MyTabbar.h"
#import "UIImage+AddFunction.h"

@implementation MyTabbar

- (void)awakeFromNib
{
//    self.opaque = YES ;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPFRAME.size.width, MY_TABBAR_HEIGHT)] ;
    backView.backgroundColor = [UIColor whiteColor] ;
    UIView *upline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPFRAME.size.width, ONE_PIXEL_VALUE)] ;
    upline.backgroundColor = COLOR_TABLE_SEP ;
    [backView addSubview:upline] ;
    [self insertSubview:backView atIndex:0] ;
    
    // 20150728 ADD BEGIN @TEASON
    [self setClipsToBounds:YES] ;
    // 20150728 ADD END   @TEASON
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize osize = [super sizeThatFits:size];
    
    if(osize.height < MY_TABBAR_HEIGHT) osize.height = MY_TABBAR_HEIGHT;
    return osize;
}

@end
