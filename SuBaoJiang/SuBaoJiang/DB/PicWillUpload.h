//
//  PicWillUpload.h
//  SuBaoJiang
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PicWillUpload : NSObject

@property (nonatomic,copy)  NSString    *nameInFolder    ;  // relative position in folder .
@property (nonatomic)       BOOL        isUploadFinished ;  // DEFAULT is False
@property (nonatomic)       int         id_PicWillUpload ;
@property (nonatomic)       int         userID ;
@property (nonatomic)       long long   tick ;

@property (nonatomic,copy)  NSString    *path ;

- (instancetype)initNewWithUserID:(int)userID
                             tick:(long long)tick ;

- (instancetype)initWithName:(NSString *)name
              uploadFinished:(BOOL)isUploadFinished
                       idPic:(int)idPic
                      userID:(int)userID
                        tick:(long long)tick ;

- (NSString *)qiNiuPath ;

- (void)cachePic:(UIImage *)image ;
- (void)cacheHeadPic:(UIImage *)image ;
- (void)cachePicNotLocal:(UIImage *)image ;
- (void)uploadPic ;
- (void)deleteThisResource ;

@end
