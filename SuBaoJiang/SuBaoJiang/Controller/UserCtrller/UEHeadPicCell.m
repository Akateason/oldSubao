//
//  UEHeadPicCell.m
//  subao
//
//  Created by TuTu on 15/9/17.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "UEHeadPicCell.h"
#import "UIImageView+WebCache.h"
#import "XTCornerView.h"


@interface UEHeadPicCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgHead ;
@end

@implementation UEHeadPicCell

- (void)tapHeadAction
{
    [self.delegate clickHeadInEditUserInfoCtrller] ;
}

- (void)awakeFromNib
{
    // Initialization code
    [XTCornerView setRoundHeadPicWithView:_imgHead] ;
    _imgHead.userInteractionEnabled = YES ;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadAction)] ;
    [_imgHead addGestureRecognizer:tapGesture] ;
}

- (void)setPicHead:(UIImage *)picHead
{
    _picHead = picHead ;
    self.imgHead.image = picHead ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
