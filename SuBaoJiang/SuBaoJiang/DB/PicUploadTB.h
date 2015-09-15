//
//  PicUploadTB.h
//  SuBaoJiang
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "DigitInformation.h"
@class PicWillUpload ;

@interface PicUploadTB : NSObject
+ (PicUploadTB *)shareInstance ;
- (BOOL)creatTable ;
- (int)getMaxID ;
- (BOOL)insertPicWillUpload:(PicWillUpload *)picture ;
- (NSMutableArray *)getAllNotUploadedPictures ;
- (NSMutableArray *)getAllUploaded ;
- (BOOL)ExistNotUploadPicture ;
- (BOOL)uploadFinishedPictureWithPictureID:(int)picID ;
@end
