//
//  NavUserCtrller.m
//  SuBaoJiang
//
//  Created by apple on 15/6/2.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "NavUserCtrller.h"

@interface NavUserCtrller ()

@end

@implementation NavUserCtrller

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        UIImage * normalImage1 = [[UIImage imageNamed:@"tabitem_user"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage * selectImage1 = [[UIImage imageNamed:@"tabitem_user_select"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:normalImage1 selectedImage:selectImage1] ;
        
//        RESIZE_TABBAR_ITEM
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
