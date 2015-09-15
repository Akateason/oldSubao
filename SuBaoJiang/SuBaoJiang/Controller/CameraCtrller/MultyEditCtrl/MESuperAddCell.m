//
//  MESuperAddCell.m
//  subao
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "MESuperAddCell.h"

@implementation MESuperAddCell

- (IBAction)addBtPressedAction:(id)sender
{
    [self.delegate superAddCellAddingBtClick] ;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
