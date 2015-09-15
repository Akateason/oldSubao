//
//  EditPreviewCtrl.h
//  subao
//
//  Created by apple on 15/8/27.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "RootCtrl.h"
#import "Article.h"

@protocol EditPreviewCtrlDelegate <NSObject>
- (void)postMultyArticle ;
@end

@interface EditPreviewCtrl : RootCtrl
@property (nonatomic,strong) id <EditPreviewCtrlDelegate> delegate ;
@property (nonatomic,strong) Article *articleSuper ;
@end
