//
//  MyCmtCell.m
//  SuBaoJiang
//
//  Created by apple on 15/6/16.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "MyCmtCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "XTCornerView.h"
#import "User.h"
#import "XTTickConvert.h"
#import "DigitInformation.h"

@interface MyCmtCell ()

@property (weak, nonatomic) IBOutlet UILabel *lb_content;
@property (weak, nonatomic) IBOutlet UILabel *lb_date;
@property (weak, nonatomic) IBOutlet UIImageView *img_pic;

@end

@implementation MyCmtCell

- (IBAction)tapHeadAction:(id)sender
{
    User *aUser = (!_cmt) ? _msg.user : _cmt.userCurrent ;
    NSNumber *userID = [NSNumber numberWithInt:aUser.u_id] ;
    [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_NOTE_2_USER object:userID] ;
}


- (void)setCmt:(ArticleComment *)cmt
{
    _cmt = cmt ;
    
    [_img_pic sd_setImageWithURL:[NSURL URLWithString:cmt.img] placeholderImage:IMG_NOPIC] ;
    
    _lb_content.text = cmt.c_content ;
    _lb_date.text = [XTTickConvert timeInfoWithDate:[XTTickConvert getNSDateWithTick:cmt.c_createtime]] ;
    
    if (!_cmt.userCurrent.u_nickname) {
        _cmt.userCurrent = G_USER ;
    }

    [_bt_head sd_setBackgroundImageWithURL:[NSURL URLWithString:_cmt.userCurrent.u_headpic] forState:UIControlStateNormal placeholderImage:IMG_HEAD_NO] ;
}

- (void)setMsg:(Msg *)msg
{
    _msg = msg ;
    
    if (msg.img) {
        [_img_pic sd_setImageWithURL:[NSURL URLWithString:msg.img]  placeholderImage:IMG_NOPIC] ;
    }
    
    _img_pic.hidden = (!msg.img) ? YES : NO ;
    
    _lb_content.text = msg.msg_content ;
    
    _lb_date.text = [XTTickConvert timeInfoWithDate:[XTTickConvert getNSDateWithTick:msg.msg_sendtime]] ;
    
    [_bt_head sd_setBackgroundImageWithURL:[NSURL URLWithString:msg.user.u_headpic] forState:UIControlStateNormal placeholderImage:IMG_HEAD_NO] ;
}

- (void)setBNoteCmt:(BOOL)bNoteCmt
{
    _bNoteCmt = bNoteCmt ;
    
    if (bNoteCmt) {
        _lb_content.text = [NSString stringWithFormat:@"%@: %@",self.msg.user.u_nickname, self.msg.msg_content] ;
    }
}

- (void)awakeFromNib
{
    // Initialization code
    [XTCornerView setRoundHeadPicWithView:_bt_head] ;
    _bt_head.layer.borderColor = COLOR_USERHEAD_BORDER.CGColor ;
    _bt_head.layer.borderWidth = ONE_PIXEL_VALUE ;
    _img_pic.contentMode = UIViewContentModeScaleAspectFit ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- calculate height
+ (CGFloat)calculateHeightWithCmt:(NSString *)content
{
    CGFloat contentWid = APPFRAME.size.width - 25.0 - 43.0 - 15.0 * 2 - 55.0 - 12.0 ;
    
    UIFont *font = [UIFont systemFontOfSize:12.0f];
    CGSize size = CGSizeMake(contentWid,200);
    CGSize labelsize = [content sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
    
    if (labelsize.height < 15) {
        labelsize.height = 15 ;
    }
    CGFloat wdH = 78.0 - 15.0 + labelsize.height ;
    
    return wdH ;
}

+ (CGFloat)calculateTableSumHeightWith:(NSMutableArray *)list
{
    float resultH = 0.0f ;
    for (int i = 0; i < list.count; i++)
    {
        ArticleComment *cmt = list[i] ;
        resultH += [self calculateHeightWithCmt:cmt
                    .c_content] ;
    }
    resultH += 15 ; // flex ?
    
    return resultH ;
}

@end
