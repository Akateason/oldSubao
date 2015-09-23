//
//  UserHeadCollectionCell.h
//  SuBaoJiang
//
//  Created by apple on 15/6/3.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ArticlePraise ;

@interface UserHeadCollectionCell : UICollectionViewCell
@property (nonatomic,strong)         ArticlePraise      *praise ;
@property (weak, nonatomic) IBOutlet UIImageView        *img_head;
@end
