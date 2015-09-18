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
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@end
@implementation UEHeadPicCell

- (void)awakeFromNib
{
    // Initialization code
    [XTCornerView setRoundHeadPicWithView:self.imgHead] ;
}

- (void)setPicHead:(UIImage *)picHead
{
    _picHead = picHead ;
    
    _imgHead.image = picHead ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
