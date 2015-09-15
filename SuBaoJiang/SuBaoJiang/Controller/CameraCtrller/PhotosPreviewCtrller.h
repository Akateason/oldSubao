//
//  MultyPreviewCtrller.h
//  subao
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "RootCtrl.h"
#import "AlbumnCell.h"
@class Article ;

@interface PhotosPreviewCtrller : RootCtrl // 相册多图预览
@property (nonatomic,strong) Article        *articleSuper ;
@property (nonatomic,copy)   NSString       *topicStr ;
@property (nonatomic,strong) UIViewController *orginCtrller ;
@property (nonatomic) Mode_SingleOrMultiple fetchMode ;
@property (nonatomic,strong) NSMutableArray *imgAssetList ;
@property (nonatomic)        int            bigestLastArticleClientID ;
@end
