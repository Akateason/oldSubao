//
//  NavLogCtller.m
//  SuBaoJiang
//
//  Created by apple on 15/6/18.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "NavLogCtller.h"
#import "ThirdLoginCtrller.h"

@interface NavLogCtller ()

@end

@implementation NavLogCtller

+ (void)modalLogCtrllerWithCurrentController:(UIViewController *)controller
{
    NavLogCtller *navCtrl = [[NavLogCtller alloc] init] ;
    
    [controller presentViewController:navCtrl animated:YES completion:^{}] ;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ThirdLoginCtrller *logCtrller = [[ThirdLoginCtrller alloc] init] ;
    logCtrller.bLaunchInNav = YES ;
    [self pushViewController:logCtrller animated:YES] ;
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
