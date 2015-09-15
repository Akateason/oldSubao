//
//  ReuseCellContent.h
//  AlbumScrollView
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>


//typedef NS_ENUM(NSInteger, ReuseCellImgType)
//{
//    mode_imgUrl = 0 , // default
//    mode_asset
//} ;


@interface ReuseCellContent : UIView
// Public obj , get from reuseScrollView.datalist
@property (nonatomic,strong) id dataObj ;
// custom it or rehabit it
//@property (nonatomic) ReuseCellImgType type ;
@end
