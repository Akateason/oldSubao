//
//  PicWillUpload.m
//  SuBaoJiang
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "PicWillUpload.h"
#import "PicUploadTB.h"
#import "QiniuSDK.h"
#import "XTFileManager.h"
#import "UIImageView+WebCache.h"
#import "CommonFunc.h"
#import "UIImage+AddFunction.h"

@implementation PicWillUpload

- (NSString *)path
{
    if (!_path)
    {
        _path = [NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0], [NSString stringWithFormat:@"%@.jpg",self.nameInFolder]] ;
    }
    return _path ;
}

- (instancetype)initNewWithUserID:(int)userID
                             tick:(long long)tick
{
    int picMaxID = [[PicUploadTB shareInstance] getMaxID] ;
    picMaxID ++ ;
    self = [self initWithName:[NSString stringWithFormat:@"%lld_%d",tick,userID]
               uploadFinished:NO
                        idPic:picMaxID
                       userID:userID
                         tick:tick] ;
    [self path] ;
    
    return self;
}

- (instancetype)initWithName:(NSString *)name
              uploadFinished:(BOOL)isUploadFinished
                       idPic:(int)idPic
                      userID:(int)userID
                        tick:(long long)tick
{
    self = [super init];
    if (self)
    {
        self.nameInFolder = name ;
        self.isUploadFinished = isUploadFinished ;
        self.id_PicWillUpload = idPic ;
        self.userID = userID ;
        self.tick = tick ;
        [self path] ;
    }
    
    return self;
}

- (void)uploadPic
{
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    // get Qiniu Token every time
    NSString *tokenQiniu = [DigitInformation shareInstance].token_QiNiuUpload ;
    if (!tokenQiniu) return ;
    
    [upManager putFile:self.path
                   key:self.nameInFolder
                 token:tokenQiniu
              complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp)
     {
         
         NSLog(@"info : %@", info);
         NSLog(@"resp : %@", resp);
         if (info.statusCode != 200) return ;
         // upload pic success
         // delete in DB
         BOOL bSuccess = [[PicUploadTB shareInstance] uploadFinishedPictureWithPictureID:self.id_PicWillUpload] ;
         // delete cache in local
//         if (bSuccess) [MyFileManager deleteFileWithFileName:self.path] ;
         // delete sdWebimageCache
         if (bSuccess) {
             [[SDImageCache sharedImageCache] removeImageForKey:[self qiNiuPath] fromDisk:YES] ;
         }
         
     } option:nil] ;
}

- (void)deleteThisResource
{
    if ([XTFileManager is_file_exist:self.path]) {
        [XTFileManager deleteFileWithFileName:self.path] ;
    }
}

- (NSString *)qiNiuPath
{
    NSString *storeString = [NSString stringWithFormat:@"%@%@",URL_QINIU_HEAD,self.nameInFolder] ;
    return storeString ;
}

- (void)cachePic:(UIImage *)image
{
    __block UIImage *img = image ;
    
    dispatch_queue_t queue = dispatch_queue_create("cachePic", NULL) ;
    dispatch_async(queue, ^{
        
        img = [UIImage compressQualityWithOriginImage:img] ;
        
        [self cachePicInloal:img] ;
        [self cachePicInSDWebImageCache:img] ;
        [self cachePicInDB] ;

    }) ;
    
}

- (void)cachePicNotLocal:(UIImage *)image
{
    __block UIImage *img = image ;

    dispatch_queue_t queue = dispatch_queue_create("cachePicNL", NULL) ;
    dispatch_async(queue, ^{
        img = [UIImage compressQualityWithOriginImage:img] ;
        
        [self cachePicInSDWebImageCache:img] ;
        [self cachePicInDB] ;
    }) ;
    
}

- (void)cachePicInloal:(UIImage *)image
{
    NSData *data = UIImageJPEGRepresentation(image,1) ;
    // write data in the file
    [[NSFileManager defaultManager] createFileAtPath:self.path
                                            contents:data
                                          attributes:nil] ;
}

- (void)cachePicInSDWebImageCache:(UIImage *)image
{
    image = [image imageCompressForWidth:image targetWidth:640] ;
    
    NSString *storeString = [self qiNiuPath] ;
    
    NSString *picInHomePage = [CommonFunc dealQiNiuUrl:storeString imgViewSize:CGSizeMake(APPFRAME.size.width, 0)] ;
    [[SDImageCache sharedImageCache] storeImage:image forKey:picInHomePage] ;
    
    float imgH = ( APPFRAME.size.width - 12 ) / 2 ;
    NSString *picInUserPage = [CommonFunc dealQiNiuUrl:storeString imgViewSize:CGSizeMake(imgH, 0)] ;
    [[SDImageCache sharedImageCache] storeImage:image forKey:picInUserPage] ;
}

- (void)cachePicInDB
{
    [[PicUploadTB shareInstance] insertPicWillUpload:self] ;
}

@end
