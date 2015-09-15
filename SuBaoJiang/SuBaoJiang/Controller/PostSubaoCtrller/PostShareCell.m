//
//  PostShareCell.m
//  SuBaoJiang
//
//  Created by apple on 15/6/29.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "PostShareCell.h"
@interface PostShareCell ()
@property (weak, nonatomic) IBOutlet UIButton *bt_weibo;
@property (weak, nonatomic) IBOutlet UIButton *bt_weixin;
@end

@implementation PostShareCell

- (IBAction)weiboPressed:(id)sender {
    _bt_weibo.selected = !_bt_weibo.selected ;

    [self.delegate weiboPressed:_bt_weibo.selected] ;
}

- (IBAction)weixinPressed:(id)sender {
    _bt_weixin.selected = !_bt_weixin.selected ;

    [self.delegate weixinPressed:_bt_weixin.selected] ;
}

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = COLOR_BG_POSTCELL ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
