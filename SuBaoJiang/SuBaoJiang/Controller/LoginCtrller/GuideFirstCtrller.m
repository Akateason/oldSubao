//
//  GuideFirstCtrller.m
//  SuBaoJiang
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "GuideFirstCtrller.h"

@interface GuideFirstCtrller ()
{
    BOOL m_bShowed ;
}
@property (weak, nonatomic) IBOutlet UIImageView *lb_word1;
@property (weak, nonatomic) IBOutlet UIImageView *img_map;
@property (weak, nonatomic) IBOutlet UIImageView *lb_word2;

@end

@implementation GuideFirstCtrller

- (void)viewDidLoad
{
    self.headTitle = _lb_word1 ;
    self.mainContents = _img_map ;
    self.tailTitle = _lb_word2 ;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startAnimate
{
    if (m_bShowed && !DEVELOPER_MODE_SWITCHER) {
        return ;
    }
    m_bShowed = YES ;
    
    [self startingAnimation] ;
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
