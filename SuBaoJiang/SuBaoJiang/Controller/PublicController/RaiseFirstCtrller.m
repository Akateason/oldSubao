//
//  RaiseFirstCtrller.m
//  SuBaoJiang
//
//  Created by apple on 15/6/2.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "RaiseFirstCtrller.h"
#import "GuideingScrollView.h"
#import "LoginSelfCtrller.h"
#import "CommonFunc.h"

@interface RaiseFirstCtrller ()<GuideingScrollViewDelegate>

@property (weak, nonatomic) IBOutlet GuideingScrollView *scrollV ; // in Class GuideingScrollView .

@end

@implementation RaiseFirstCtrller

+ (void)showGuidingWithController:(UIViewController *)ctrller
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    RaiseFirstCtrller *raiseCtrller = [story instantiateViewControllerWithIdentifier:@"RaiseFirstCtrller"] ;
    raiseCtrller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve ;
    [ctrller presentViewController:raiseCtrller animated:YES completion:^{}] ;
}

- (void)viewDidLoad
{
    [super viewDidLoad] ;
    // Do any additional setup after loading the view.
    
    self.myTitle = @"启动页" ;
    
    _scrollV.guidingDelegate = self ;
    _scrollV.currentCtrller  = self ;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone] ;
    [self.navigationController setNavigationBarHidden:YES animated:NO] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone] ;
    [self.navigationController setNavigationBarHidden:NO animated:NO] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
- (void)dismiss
{
//    [self.navigationController popViewControllerAnimated:NO] ;
    [self dismissViewControllerAnimated:YES completion:^{}] ;
}

#pragma mark --
#pragma mark - guiding delegate
- (void)logSelf
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    LoginSelfCtrller *loginSelfCtrller = [story instantiateViewControllerWithIdentifier:@"LoginSelfCtrller"] ;
    [self.navigationController pushViewController:loginSelfCtrller animated:YES] ;
}

- (void)seeMore
{
    [self dismiss] ;
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
