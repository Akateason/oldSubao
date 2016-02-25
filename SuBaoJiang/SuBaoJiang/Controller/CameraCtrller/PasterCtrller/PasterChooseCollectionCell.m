//
//  PasterChooseCollectionCell.m
//  subao
//
//  Created by TuTu on 16/2/25.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "PasterChooseCollectionCell.h"
#import "Paster.h"
#import "UIImageView+WebCache.h"
#import "CommonFunc.h"

@interface PasterChooseCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView    *imgPaster;
@property (weak, nonatomic) IBOutlet UILabel        *lb_namePaster;

@end

@implementation PasterChooseCollectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setAPaster:(Paster *)aPaster
{
    _aPaster = aPaster ;
    
    _lb_namePaster.text = aPaster.name ;
    
    UIImage *headImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:aPaster.url
                                                                    withCacheWidth:640] ;
    if (!headImage) {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:aPaster.url]
                                                              options:0
                                                             progress:nil
                                                            completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                                
                                                                NSString *key = [CommonFunc dealQiNiuUrl:aPaster.url imgViewSize:CGSizeMake(640, 0)] ;
                                                                [[SDImageCache sharedImageCache] storeImage:image forKey:key] ;
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    _imgPaster.image = image ;
                                                                }) ;
                                                                
                                                            }] ;
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            _imgPaster.image = headImage ;
        }) ;
    }
    

}



@end
