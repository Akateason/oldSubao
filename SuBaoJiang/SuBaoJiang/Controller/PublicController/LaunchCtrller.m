//
//  LaunchCtrller.m
//  subao
//
//  Created by TuTu on 16/1/21.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "LaunchCtrller.h"

@interface LaunchCtrller ()

@end

@implementation LaunchCtrller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

static float kDuration = 1. ;

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:kDuration
                     animations:^{
                         
        self.view.alpha = 0. ;
        self.view.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.2, 1.2, 1);
                         
    } completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:NO
                                 completion:^{
                                     
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
                                     
        }];
        
    }] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
