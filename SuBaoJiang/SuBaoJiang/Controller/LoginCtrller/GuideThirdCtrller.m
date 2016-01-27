//
//  GuideThirdCtrller.m
//  subao
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "GuideThirdCtrller.h"
#import "XTAnimation.h"

@interface GuideThirdCtrller ()
{
    BOOL m_bShowed ;
}
@property (weak, nonatomic) IBOutlet UIImageView *word1;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIImageView *word2;

@end

@implementation GuideThirdCtrller

- (void)viewDidLoad
{
    self.headTitle = _word1 ;
    self.mainContents = _img ;
    self.tailTitle = _word2 ;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
