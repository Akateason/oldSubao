//
//  UESelectCell.m
//  subao
//
//  Created by TuTu on 15/9/21.
//  Copyright © 2015年 teason. All rights reserved.
//

#import "UESelectCell.h"

@interface UESelectCell ()
@property (weak, nonatomic) IBOutlet UILabel *lb_choosen;
@end

@implementation UESelectCell

- (void)setRow:(long)row
{
    _row = row ;
    
    _lb_choosen.text = !row ? @"男" : @"女" ;
}


- (void)awakeFromNib
{
    // Initialization code
    self.accessoryType = UITableViewCellAccessoryNone ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
