//
//  NoteAlamCell.m
//  SuBaoJiang
//
//  Created by apple on 15/7/31.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "NoteAlamCell.h"

@interface NoteAlamCell ()
@property (weak, nonatomic) IBOutlet UIImageView    *img_icon;
@property (weak, nonatomic) IBOutlet UILabel        *lb_title;
@property (weak, nonatomic) IBOutlet UIButton       *bt_Count;
@property (weak, nonatomic) IBOutlet UIImageView    *img_arrow;
@end

@implementation NoteAlamCell

- (void)setType:(TYPE_NoteAlam)type
{
    _type = type ;
    
    switch (type)
    {
        case typeComment:
        {
            _img_icon.image = [UIImage imageNamed:@"ncvc_icon_comment"] ;
            _lb_title.text  = @"评论" ;
        }
            break;
        case typePraise:
        {
            _img_icon.image = [UIImage imageNamed:@"ncvc_icon_praise"] ;
            _lb_title.text  = @"喜欢" ;
        }
            break;
        default:
            break;
    }
}

- (void)setNoteCount:(NSInteger)noteCount
{
    _noteCount = noteCount ;
    
    _bt_Count.hidden = (!noteCount) ;
    [_bt_Count setTitle:[NSString stringWithFormat:@"%li",(long)noteCount]
               forState:0] ;
}


- (void)awakeFromNib
{
    // Initialization code
    _bt_Count.hidden = YES ;
    _bt_Count.userInteractionEnabled = NO ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
