//
//  PasterChooseView.m
//  subao
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "PasterChooseView.h"
#import "UIImageView+WebCache.h"
#import "CommonFunc.h"

@interface PasterChooseView ()
@property (weak, nonatomic) IBOutlet UIImageView    *imgPaster;
@property (weak, nonatomic) IBOutlet UILabel        *lb_namePaster;
@property (weak, nonatomic) IBOutlet UIButton *bt_bg;
@end

@implementation PasterChooseView

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
    
//    [_imgPaster sd_setImageWithURL:[NSURL URLWithString:aPaster.url] ] ;
}

- (IBAction)btBackgroundClickAction:(id)sender
{
    [self.delegate pasterClick:self.aPaster] ;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
