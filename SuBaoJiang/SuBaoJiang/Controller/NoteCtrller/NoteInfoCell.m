//
//  NoteInfoCell.m
//  subao
//
//  Created by apple on 15/8/3.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "NoteInfoCell.h"
#import "Msg.h" 
#import "UIImageView+WebCache.h"
#import "XTCornerView.h"
#import "User.h"
#import "XTTickConvert.h"

@interface NoteInfoCell ()
@property (weak, nonatomic) IBOutlet UIImageView    *img_sender;
@property (weak, nonatomic) IBOutlet UILabel        *lb_name;
@property (weak, nonatomic) IBOutlet UILabel        *lb_content;
@property (weak, nonatomic) IBOutlet UILabel        *lb_date;
@property (weak, nonatomic) IBOutlet UIImageView    *img_advertisement;

@property (nonatomic)                BOOL           emptyAdvertiseImage; // true -> imgAdver is null ; false -> has imgAdver
@end

@implementation NoteInfoCell

+ (CGFloat)calculateHeightWithMsg:(Msg *)msg
{
    BOOL emptyAdvImage = (!msg.img || !msg.img.length) ;
    
    CGFloat width_lbContent = APPFRAME.size.width - 86.0 - 20.0 ;
    UIFont *font = [UIFont systemFontOfSize:15.0f];
    CGSize size = CGSizeMake(width_lbContent,300.0);
    CGSize labelsize = [msg.msg_content sizeWithFont:font
                                   constrainedToSize:size
                                       lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height_lbContent = (labelsize.height < 18.0) ? 18.0 : labelsize.height;
    
    CGFloat onlyWordsHeight = 45.0 + height_lbContent + 18.0 ;
    
    if (emptyAdvImage)
    {
        // only words ;
        return onlyWordsHeight ;
    }
    else
    {
        // has picture
        // get image's Height
        CGFloat w_imgAdvertise = APPFRAME.size.width - 86.0 - 20.0 ;
        CGFloat H_imgAdvertise = w_imgAdvertise * 28.0 / 54.0 ;
        return onlyWordsHeight + 15.0 + H_imgAdvertise ;
    }
    
    return 0 ;
}

- (void)setMsg:(Msg *)msg
{
    _msg = msg ;
    
    // img sender
    [_img_sender sd_setImageWithURL:[NSURL URLWithString:msg.user.u_headpic]
                   placeholderImage:IMG_HEAD_NO] ;
    // lb name
    _lb_name.text = (!msg.user.u_nickname) ? @"速报酱" : msg.user.u_nickname ;
    // lb content
    _lb_content.text = msg.msg_content ;
    _lb_content.highlightedTextColor = COLOR_MAIN ;

    
    // lb date
    _lb_date.text = [XTTickConvert timeInfoWithDate:[XTTickConvert getNSDateWithTick:msg.msg_sendtime]] ;
    // img advertise
    self.emptyAdvertiseImage = (!msg.img || [msg.img isEqualToString:@""]) ;
    _img_advertisement.hidden = self.emptyAdvertiseImage ;
    if (self.emptyAdvertiseImage) return ;
    [_img_advertisement sd_setImageWithURL:[NSURL URLWithString:msg.img]] ;
}


- (void)awakeFromNib
{
    // Initialization code
    [XTCornerView setRoundHeadPicWithView:_img_sender] ;
    _img_sender.layer.borderColor = COLOR_USERHEAD_BORDER.CGColor ;
    _img_sender.layer.borderWidth = ONE_PIXEL_VALUE ;
    
    _img_advertisement.backgroundColor = COLOR_BACKGROUND ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
