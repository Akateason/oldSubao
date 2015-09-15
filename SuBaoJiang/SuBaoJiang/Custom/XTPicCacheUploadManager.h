//
//  TeaPicCacheUploadManager.h
//  SuBaoJiang
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTPicCacheUploadManager : NSObject
+ (XTPicCacheUploadManager *)shareInstance ;
- (void)closeLoop ;
- (void)uploadInLoops ;
- (void)deleInLoops ;
@end
