//
//  CameraGroupCell.m
//  SuBaoJiang
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "CameraGroupCell.h"

@interface CameraGroupCell ()

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lb;

@end

@implementation CameraGroupCell

- (void)setGroup:(ALAssetsGroup *)group
{
    _group = group ;
    
    @autoreleasepool {
        _img.image = [UIImage imageWithCGImage:[group posterImage]] ;
        NSString *strShow = [NSString stringWithFormat:@"%@（%d）",[group valueForProperty:ALAssetsGroupPropertyName],(int)[group numberOfAssets]] ;
        _lb.text = strShow ;
    }
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)dealloc
{
    _group = nil ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
