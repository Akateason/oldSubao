//
//  AlbumnCell.m
//  SuBaoJiang
//
//  Created by apple on 15/6/24.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "AlbumnCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface AlbumnCell ()
//UIs
@property (weak, nonatomic) IBOutlet UIImageView *img_takePhoto;
@property (weak, nonatomic) IBOutlet UIImageView *img_picSelect;

@end

@implementation AlbumnCell

#pragma mark --
#pragma mark - Inital
- (void)awakeFromNib
{
    _img.backgroundColor = COLOR_HEADER_BACK ;
    _img.contentMode = UIViewContentModeScaleAspectFit ;
    _img_takePhoto.hidden = YES ;
    _img_picSelect.hidden = YES ;
}

#pragma mark --
#pragma mark - Prop
- (void)setBTakePhoto:(BOOL)bTakePhoto
{
    _bTakePhoto = bTakePhoto ;
    
    _img_takePhoto.hidden = !bTakePhoto ;
    _img.hidden = bTakePhoto ;
}

- (void)setFetchMode:(Mode_SingleOrMultiple)fetchMode
{
    _fetchMode = fetchMode ;
    
    _img_picSelect.hidden = (fetchMode == mode_single || fetchMode == mode_addSingle) ;
}

- (void)setPicSelected:(BOOL)picSelected
{
    _picSelected = picSelected ;
    
    NSString *imgStr = picSelected ? @"camera_picSelect_On" : @"camera_picSelect_Off" ;
    _img_picSelect.image = [UIImage imageNamed:imgStr] ;
}

@end
