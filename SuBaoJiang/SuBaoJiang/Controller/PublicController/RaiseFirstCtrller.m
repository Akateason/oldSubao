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

@property (weak, nonatomic) IBOutlet GuideingScrollView *scrollV;

@end

@implementation RaiseFirstCtrller

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.myTitle = @"启动页" ;
    
    _scrollV.hidden = YES ;
    _scrollV.guidingDelegate = self ;
    _scrollV.currentCtrller = self ;
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


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;
    
    BOOL isFirstLoadApp = [CommonFunc isFirstLoad] ;
    
//    test
//    isFirstLoadApp = YES ;
    
    [self straightGo2Index:isFirstLoadApp] ;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)raiseToFirst
{
    [self performSegueWithIdentifier:@"raise2tab" sender:nil] ;
}


#pragma mark --
- (void)straightGo2Index:(BOOL)b
{
    if (!b)
    {
        _scrollV.hidden = YES ;
        [self raiseToFirst] ;
    }
    else
    {
        _scrollV.hidden = NO ;
    }
}

#pragma mark - guiding delegate
- (void)logSelf
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    LoginSelfCtrller *loginSelfCtrller = [story instantiateViewControllerWithIdentifier:@"LoginSelfCtrller"] ;
    [self.navigationController pushViewController:loginSelfCtrller animated:YES] ;
}

- (void)seeMore
{
    [self raiseToFirst] ;
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
