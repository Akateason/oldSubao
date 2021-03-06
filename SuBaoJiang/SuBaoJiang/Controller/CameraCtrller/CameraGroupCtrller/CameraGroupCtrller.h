//
//  CameraGroupCtrller.h
//  SuBaoJiang
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"
@class ALAssetsLibrary ;
@class ALAssetsGroup ;

@protocol CameraGroupCtrllerDelegate <NSObject>
- (void)selectAlbumnGroup:(ALAssetsGroup *)group ;
@end

@interface CameraGroupCtrller : RootCtrl

@property (nonatomic, weak)   id <CameraGroupCtrllerDelegate> delegate ;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary ;

@end
