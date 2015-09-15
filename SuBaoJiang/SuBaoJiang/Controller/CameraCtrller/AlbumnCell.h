//
//  AlbumnCell.h
//  SuBaoJiang
//
//  Created by apple on 15/6/24.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, Mode_SingleOrMultiple)
{
    mode_single     = 0 , // 单图选择, 单图编辑 default
    mode_addSingle  = 1 , // 单图选择, 多图编辑
    mode_multip     = 2 , // 多图选择, 无主图
    mode_addMulty   = 3   // 多图选择, 有主图
} ;

@interface AlbumnCell : UICollectionViewCell

//Attrs
@property (nonatomic) BOOL bTakePhoto ;
@property (nonatomic) Mode_SingleOrMultiple fetchMode ;
@property (nonatomic) BOOL picSelected ;

//UIs
@property (weak, nonatomic) IBOutlet UIImageView *img_takePhoto;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIImageView *img_picSelect;
@end
