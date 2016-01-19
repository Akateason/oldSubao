//
//  AlbumOperation.h
//  subao
//
//  Created by TuTu on 16/1/19.
//  Copyright © 2016年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ALAsset ;
typedef void(^CompletionBlock)(UIImage *resultImage) ;

@interface AlbumOperation : NSOperation

@property (nonatomic, strong)   NSIndexPath *indexPath ;

- (instancetype)initWithAsset:(ALAsset *)asset
                    indexPath:(NSIndexPath *)indexPath
                   completion:(void (^)(UIImage *resultImage))completion ;

@end
