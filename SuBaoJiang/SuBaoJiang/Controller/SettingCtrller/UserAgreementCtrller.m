//
//  UserAgreementCtrller.m
//  SuBaoJiang
//
//  Created by apple on 15/7/1.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "UserAgreementCtrller.h"

#define URL_AGREEMENT   @"http://www.subaojiang.com/setting_terms.html"

@interface UserAgreementCtrller ()

@end

@implementation UserAgreementCtrller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.urlStr = URL_AGREEMENT ;
    
    self.myTitle = @"用户协议页" ;
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
