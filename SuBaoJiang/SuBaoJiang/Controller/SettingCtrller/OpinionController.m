//
//  OpinionController.m
//  SuBaoJiang
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "OpinionController.h"

@interface OpinionController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *tv;

@end

@implementation OpinionController

- (IBAction)sendButtonPressedAction:(id)sender
{
    [ServerRequest settingOpinionContent:_tv.text success:^(id json) {

        ResultParsered *result = [[ResultParsered alloc] initWithDic:json] ;
        if (result.errCode) {
            [XTHudManager showWordHudWithTitle:WD_HUD_SEND_FAIL] ;
            return ;
        }
        [self.navigationController popViewControllerAnimated:YES] ;
        [XTHudManager showWordHudWithTitle:WD_HUD_SEND_SUCCESS] ;
        
    } fail:^{
        [XTHudManager showWordHudWithTitle:WD_HUD_FAIL_RETRY] ;
    }] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myTitle = @"意见反馈页" ;
    
    _tv.text = @"请在这里填写您对我们的意见,感谢使用,让速报酱做得越来越好!" ;
    _tv.delegate = self ;
    _tv.backgroundColor = [UIColor whiteColor] ;
    _tv.textColor = [UIColor lightGrayColor] ;
    
    self.view.backgroundColor = COLOR_BACKGROUND ;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark --
#pragma mark - textview delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.text = @"" ;
    
    return YES ;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES ;
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
