//
//  IntroductionCtrller.m
//  SuBaoJiang
//
//  Created by apple on 15/7/1.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "IntroductionCtrller.h"
#import "GuideingScrollView.h"

@interface IntroductionCtrller () <GuideingScrollViewDelegate>

@property (weak, nonatomic) IBOutlet GuideingScrollView *scrollV;

@end

@implementation IntroductionCtrller

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myTitle = @"功能介绍页" ;
    
    _scrollV.guidingDelegate = self ;
    _scrollV.isAboutUS = YES ;
    _scrollV.currentCtrller = self ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - guiding delegate
- (void)seeMore
{
    [self.navigationController popViewControllerAnimated:YES] ;
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
