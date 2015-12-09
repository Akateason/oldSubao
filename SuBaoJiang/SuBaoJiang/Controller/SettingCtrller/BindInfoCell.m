//
//  BindInfoCell.m
//  SuBaoJiang
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "BindInfoCell.h"

@interface BindInfoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;

@end


@implementation BindInfoCell

- (void)awakeFromNib {
    // Initialization code
    
    
    MODE_bind mode =  [[CommonFunc getBindMode] intValue] ;
    
    switch (mode) {
        case mode_none:
        {
            _lb_content.text = @"未绑定" ;
        }
            break;
        case mode_weibo:
        {
            _img.image = [UIImage imageNamed:@"bind_weibo"] ;
            _lb_content.text = @"已绑定您的新浪微博" ;
        }
            break;
        case mode_weixin:
        {
            _img.image = [UIImage imageNamed:@"bind_weixin"] ;
            _lb_content.text = @"已绑定您的微信" ;
        }
            break;
        default:
            break;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)setBindMode:(MODE_bind)bindMode
//{
//    _bindMode = bindMode ;
//    
//    
//}


@end
