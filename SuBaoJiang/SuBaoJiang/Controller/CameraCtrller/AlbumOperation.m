//
//  AlbumOperation.m
//  subao
//
//  Created by TuTu on 16/1/19.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "AlbumOperation.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface AlbumOperation ()

@property (nonatomic, strong)   ALAsset *asset ;
@property (nonatomic, copy)     CompletionBlock completion ;

@end

@implementation AlbumOperation

- (instancetype)initWithAsset:(ALAsset *)asset
                    indexPath:(NSIndexPath *)indexPath
                   completion:(void (^)(UIImage *resultImage))completion
{
    self = [super init];
    if (self) {
        self.asset = asset ;
        self.indexPath = indexPath ;
        self.completion = completion ;
    }
    return self;
}

- (void)main
{
    if (self.isCancelled) return;
    CGImageRef aspectRatioThumbnail = [self.asset aspectRatioThumbnail] ;
    if (self.isCancelled) return;
    UIImage *imgAspectRatio = [UIImage imageWithCGImage:aspectRatioThumbnail] ;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isCancelled) return;
        if (self.completion) {
            self.completion(imgAspectRatio) ;
        }
    }) ;
}

@end
