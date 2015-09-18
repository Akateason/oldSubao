//
//  UETextfieldCell.m
//  subao
//
//  Created by TuTu on 15/9/17.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "UETextfieldCell.h"
@interface UETextfieldCell ()
@property (weak, nonatomic) IBOutlet UILabel *lb_key;
@property (weak, nonatomic) IBOutlet UITextField *tf_val;
@end

@implementation UETextfieldCell

- (void)awakeFromNib
{
    // Initialization code
    _tf_val.backgroundColor = [UIColor whiteColor] ;
}

- (void)setStrWillShow:(NSString *)strWillShow
{
    _strWillShow = strWillShow ;
    
    _tf_val.text = strWillShow ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
