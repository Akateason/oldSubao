//
//  DetailSubaoCtrller+TaskModuleTransition.m
//  subao
//
//  Created by TuTu on 16/1/25.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "DetailSubaoCtrller+TaskModuleTransition.h"

@implementation DetailSubaoCtrller (TaskModuleTransition)

+ (void)jump2DetailSubaoCtrller:(UIViewController *)ctrller
               AndWithArticleID:(int)aID
{
    [self jump2DetailSubaoCtrller:ctrller
                 AndWithArticleID:aID
                 AndWithCommentID:0] ;
}

+ (void)jump2DetailSubaoCtrller:(UIViewController *)ctrller
               AndWithArticleID:(int)aID
               AndWithCommentID:(int)commentID
{
    [self jump2DetailSubaoCtrller:ctrller
                 AndWithArticleID:aID
                 AndWithCommentID:commentID
                         FromRect:CGRectZero
                          imgSend:nil] ;
}

+ (void)jump2DetailSubaoCtrller:(UIViewController *)ctrller
               AndWithArticleID:(int)aID
               AndWithCommentID:(int)commentID
                       FromRect:(CGRect)fromRect
                        imgSend:(UIImage *)imgSend
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    DetailSubaoCtrller *detailCtrller = [story instantiateViewControllerWithIdentifier:@"DetailSubaoCtrller"] ;
    detailCtrller.superArticleID = aID ;
    detailCtrller.replyCommentID = commentID ;
    detailCtrller.fromRect = fromRect ;
    detailCtrller.imgArticleSend = imgSend ;
    if ([ctrller isKindOfClass:[HomeController class]]) {
        detailCtrller.homeCtrller = (HomeController *)ctrller ;
    }
    
    [detailCtrller setHidesBottomBarWhenPushed:YES] ;
    [ctrller.navigationController pushViewController:detailCtrller animated:NO] ;
}


@end
