//
//  ReplyCell.m
//  SuBaoJiang
//
//  Created by apple on 15/6/3.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "ReplyCell.h"
#import "XTTickConvert.h"
//#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "User.h"
#import "XTCornerView.h"

@interface ReplyCell ()

@property (weak, nonatomic) IBOutlet UIButton *bt_userHead;
@property (weak, nonatomic) IBOutlet UILabel *lb_uName;
@property (weak, nonatomic) IBOutlet UILabel *lb_date;
@property (weak, nonatomic) IBOutlet UILabel *lb_comment;

@end

@implementation ReplyCell

- (void)awakeFromNib
{
    // Initialization code
    _bt_userHead.backgroundColor = nil ;
    _bt_userHead.tintColor = nil ;
    
    [XTCornerView setRoundHeadPicWithView:_bt_userHead] ;
    _bt_userHead.layer.borderColor = COLOR_USERHEAD_BORDER.CGColor ;
    _bt_userHead.layer.borderWidth = ONE_PIXEL_VALUE ;
    
    _lb_uName.textColor = COLOR_BLACK_DARK ;
    _lb_comment.textColor = COLOR_GRAY_CONTENT ;
    _lb_date.textColor = COLOR_GRAY_CONTENT ;
}

- (void)dealloc
{
    self.comment = nil ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)tap:(id)sender
{
    [self.delegate clickUserHead:_comment.userCurrent.u_id] ;
}

#pragma mark --
#pragma mark - setter
- (void)setComment:(ArticleComment *)comment
{
    _comment = comment ;
    
    // head
    [_bt_userHead sd_setBackgroundImageWithURL:[NSURL URLWithString:_comment.userCurrent.u_headpic] forState:UIControlStateNormal placeholderImage:IMG_HEAD_NO] ;
    // name
    _lb_uName.text = _comment.userCurrent.u_nickname ;
    // content
    _lb_comment.text = _comment.showStrComment ;
    // date
    _lb_date.text = [XTTickConvert getDateWithTick:_comment.c_createtime AndWithFormart:TIME_STR_FORMAT_8] ;

}

#pragma mark --
- (CGFloat)calculateHeightWithCmtStr:(NSString *)cmtStr
{
    UIFont *font = [UIFont systemFontOfSize:14.0f] ;
    CGSize size = CGSizeMake(APPFRAME.size.width - 15 - 6 - 9 - 30 ,200) ;
    CGSize labelsize = [cmtStr boundingRectWithSize:size
                                            options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         attributes:@{NSFontAttributeName:font}
                                            context:nil].size ;
    CGFloat wordH = labelsize.height ;
    if (wordH < 17.0) wordH = 17.0 ;
    return 64.0  - 17.0 + wordH ;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, [self calculateHeightWithCmtStr:self.comment.showStrComment]) ;
}

@end
