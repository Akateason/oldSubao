//
//  PictureHeader.h
//  SuBaoJiang
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#ifndef SuBaoJiang_PictureHeader_h
#define SuBaoJiang_PictureHeader_h


// Global Images
#define IMG_NOPIC               [UIImage imageNamed:@"nopic"]
#define IMG_HEAD_NO             [UIImage imageNamed:@"headNo"]
#define IMG_PHONE_WID(S,W)      [S stringByAppendingString:[NSString stringWithFormat:@"?imageView/2/w/%@",@(W)]]

#define IMG_RANDOM              @"?__t="

// Qiniu url
#define URL_QINIU_HEAD          @"http://img.subaojiang.com/"

#define STR_IMG_NO              @"http://7xiibs.com2.z0.glb.qiniucdn.com/user-temp-headpic.png"

//@"http://7xiibs.com2.z0.glb.qiniucdn.com/"
//@"http://img.subaojiang.com/"

#endif
