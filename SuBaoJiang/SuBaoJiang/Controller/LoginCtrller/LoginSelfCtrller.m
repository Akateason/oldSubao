//
//  LoginSelfCtrller.m
//  SuBaoJiang
//
//  Created by apple on 15/6/18.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "LoginSelfCtrller.h"
#import "CommonFunc.h"
#import "XTVerification.h"

@interface LoginSelfCtrller () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tf_account;
@property (weak, nonatomic) IBOutlet UITextField *tf_secret;

@property (weak, nonatomic) IBOutlet UIButton *btLogin;


@end

@implementation LoginSelfCtrller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"自登陆页" ;
    _btLogin.layer.cornerRadius = 4 ;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO] ;
    
    _tf_account.delegate   = self ;
    _tf_secret.delegate    = self ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Actions
- (IBAction)registerAction:(id)sender
{
    [self performSegueWithIdentifier:@"log2reg" sender:nil] ;
}

- (IBAction)loginAction:(id)sender
{
    if (!_tf_account.text.length || !_tf_secret.text.length) {
        [XTHudManager showWordHudWithTitle:@"请完善您的资料"] ;
        return ;
    }
    
    if (![XTVerification validateUserName:_tf_account.text]) {
        [XTHudManager showWordHudWithTitle:@"请输入正确的用户名格式"] ;
        return ;
    }
    if (![XTVerification validatePassword:_tf_secret.text]) {
        [XTHudManager showWordHudWithTitle:@"请输入正确的密码格式(6-15位)"] ;
        return ;
    }
    
    [ServerRequest loginUnitWithCategory:mode_Local wxopenID:nil wxUnionID:nil nickName:nil gender:nil language:nil country:nil province:nil city:nil headpic:nil wbuid:nil description:nil username:_tf_account.text password:_tf_secret.text
     Success:^(id json) {
         ResultParsered *result = [[ResultParsered alloc] initWithDic:json] ;
         [CommonFunc logSussessedWithResult:result AndWithController:self] ;
     } fail:^{
         [XTHudManager showWordHudWithTitle:WD_HUD_FAIL_RETRY] ;
     }] ;
    
    
}



#pragma mark --
#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - touchesEnded withEvent
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (![self.tf_account isExclusiveTouch]||![self.tf_secret isExclusiveTouch])
    {
        [self.tf_secret resignFirstResponder]      ;
        [self.tf_account resignFirstResponder]     ;
    }
    
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
