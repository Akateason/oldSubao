//
//  GuidingSuperCtrller.m
//  subao
//
//  Created by TuTu on 16/1/27.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "GuidingSuperCtrller.h"

@interface GuidingSuperCtrller ()

@end

@implementation GuidingSuperCtrller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.headTitle.hidden = YES ;
    self.mainContents.hidden = YES ;
    self.tailTitle.hidden = YES ;
}

- (void)dealloc
{
    self.headTitle = nil ;
    self.mainContents = nil ;
    self.tailTitle = nil ;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startingAnimation
{
    [self animationHeadTitle] ;
}

- (void)animationHeadTitle
{
    _headTitle.transform = CGAffineTransformMakeTranslation(0, -100) ;
    
    [UIView transitionWithView:_headTitle
                      duration:0.8
                       options:UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        _headTitle.hidden = NO ;
                        _headTitle.transform = CGAffineTransformIdentity ;
                    }
                    completion:^(BOOL finished) {

                        [self animationContent] ;
                        [self animationTailTitle] ;

                    }] ;

}

- (void)animationContent
{
    _mainContents.transform = CGAffineTransformScale(_mainContents.transform, 0.2, 0.2) ;
    
    [UIView transitionWithView:_mainContents
                      duration:0.6
                       options:UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        _mainContents.hidden = NO ;
                        _mainContents.transform = CGAffineTransformIdentity ;
                    }
                    completion:^(BOOL finished) {
                    }] ;

}

- (void)animationTailTitle
{
//    _tailTitle.transform = CGAffineTransformMakeTranslation(0, 100) ;
    
    [UIView transitionWithView:_tailTitle
                      duration:1.3
                       options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionTransitionFlipFromBottom
                    animations:^{
                        _tailTitle.hidden = NO ;
//                        _tailTitle.transform = CGAffineTransformIdentity ;
                    }
                    completion:^(BOOL finished) {
                    }] ;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
