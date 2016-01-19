//
//  AlbumnCell.h
//  SuBaoJiang
//
//  Created by apple on 15/6/24.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ALAsset ;

typedef NS_ENUM(NSInteger, Mode_SingleOrMultiple)
{
    mode_single     = 0 , // 单图选择, 单图编辑 default
    mode_addSingle  = 1 , // 单图选择, 多图编辑
    mode_multip     = 2 , // 多图选择, 无主图
    mode_addMulty   = 3   // 多图选择, 有主图
} ;

@interface AlbumnCell : UICollectionViewCell

//Attrs
@property (nonatomic) BOOL                       bTakePhoto ;    // only in singleType . set a take photo icon .
@property (nonatomic) Mode_SingleOrMultiple      fetchMode ;     // Mode_SingleOrMultiple
@property (nonatomic) BOOL                       picSelected ;   // only in multyType
//UIs
@property (weak, nonatomic) IBOutlet UIImageView *img ;

@end
