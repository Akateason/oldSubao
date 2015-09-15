//
//  PostMoreCell.m
//  subao
//
//  Created by apple on 15/8/18.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "PostMoreCell.h"
@interface PostMoreCell ()
@property (weak, nonatomic) IBOutlet UIView *topbar;
@end

@implementation PostMoreCell

- (void)awakeFromNib {
    // Initialization code
    _topbar.backgroundColor = COLOR_BG_POSTCELL ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
