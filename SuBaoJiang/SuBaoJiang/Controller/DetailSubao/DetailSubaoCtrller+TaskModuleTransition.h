//
//  DetailSubaoCtrller+TaskModuleTransition.h
//  subao
//
//  Created by TuTu on 16/1/25.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "DetailSubaoCtrller.h"

@interface DetailSubaoCtrller (TaskModuleTransition)

+ (void)jump2DetailSubaoCtrller:(UIViewController *)ctrller
               AndWithArticleID:(int)aID ;

+ (void)jump2DetailSubaoCtrller:(UIViewController *)ctrller
               AndWithArticleID:(int)aID
               AndWithCommentID:(int)commentID ;

+ (void)jump2DetailSubaoCtrller:(UIViewController *)ctrller
               AndWithArticleID:(int)aID
               AndWithCommentID:(int)commentID
                       FromRect:(CGRect)fromRect
                        imgSend:(UIImage *)imgSend ;

@end
