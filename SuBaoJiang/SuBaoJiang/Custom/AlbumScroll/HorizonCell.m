//
//  HorizonCell.m
//  subao
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "HorizonCell.h"
#import "ReuseCellContent.h"


@interface HorizonCell ()
@property (nonatomic,strong) ReuseCellContent *reuseContent ;
@end

@implementation HorizonCell

- (ReuseCellContent *)reuseContent
{
    if (!_reuseContent)
    {
        _reuseContent = [[ReuseCellContent alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width , self.frame.size.height)] ;
        if (![_reuseContent superview]) {
            [self.contentView addSubview:_reuseContent] ;
        }
    }
    
    return _reuseContent ;
}

- (void)setDataObject:(id)dataObject
{
    _dataObject = dataObject ;
    
    self.reuseContent.dataObj = dataObject ;
}

- (void)awakeFromNib
{
    // Initialization code
    [self reuseContent] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
