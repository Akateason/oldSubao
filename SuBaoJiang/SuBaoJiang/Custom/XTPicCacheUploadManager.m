//
//  TeaPicCacheUploadManager.m
//  SuBaoJiang
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "XTPicCacheUploadManager.h"
#import "PicUploadTB.h"
#import "PicWillUpload.h"
@interface XTPicCacheUploadManager ()
{
    NSTimer *_timerUpload ;
    NSTimer *_timerDelete ;
}
@end

@implementation XTPicCacheUploadManager

- (void)dealloc
{
    [self closeLoop] ;
}

+ (XTPicCacheUploadManager *)shareInstance
{
    static dispatch_once_t pred ;
    static XTPicCacheUploadManager *manager ;
    dispatch_once(&pred, ^{
        manager = [[XTPicCacheUploadManager alloc] init] ;
    }) ;
    
    return manager ;
}

- (void)closeLoop
{
    [_timerUpload invalidate] ;
    _timerUpload = nil ;
    
    [_timerDelete invalidate] ;
    _timerDelete = nil ;
}

- (void)uploadInLoops
{
    if (!_timerUpload)
    {
        _timerUpload = [NSTimer scheduledTimerWithTimeInterval:60
                                                  target:self
                                                selector:@selector(uploading)
                                                userInfo:nil
                                                 repeats:YES] ;
        [[NSRunLoop currentRunLoop] addTimer:_timerUpload forMode:NSRunLoopCommonModes] ;
    }
}

- (void)uploading
{
    BOOL bExist = [[PicUploadTB shareInstance] ExistNotUploadPicture] ;
    if (!bExist) return ;
    NSLog(@"exist picture to uploading") ;
    NSArray *listWillUpdate = [[PicUploadTB shareInstance] getAllNotUploadedPictures] ;
    [listWillUpdate makeObjectsPerformSelector:@selector(uploadPic)] ;
}

- (void)deleInLoops
{
    if (!_timerDelete)
    {
        _timerDelete = [NSTimer scheduledTimerWithTimeInterval:60*60
                                                  target:self
                                                selector:@selector(delRubbish)
                                                userInfo:nil
                                                 repeats:YES] ;
        [[NSRunLoop currentRunLoop] addTimer:_timerDelete forMode:NSRunLoopCommonModes] ;
    }

}

- (void)delRubbish
{
    NSArray *listWillDelete = [[PicUploadTB shareInstance] getAllUploaded] ;
    [listWillDelete makeObjectsPerformSelector:@selector(deleteThisResource)] ;
}

@end
