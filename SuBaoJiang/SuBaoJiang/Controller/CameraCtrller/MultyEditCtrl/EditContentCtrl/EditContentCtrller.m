//
//  EditContentCtrller.m
//  subao
//
//  Created by apple on 15/8/20.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "EditContentCtrller.h"
#import "Article.h"


@interface EditContentCtrller () <UITextViewDelegate>
{
    BOOL keyBoardIsUp ;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomFlex;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation EditContentCtrller

#pragma mark --
#pragma mark - Initialization
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(UIKeyboardDidChange:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
}

#pragma mark --
#pragma mark - notification
- (void)keyboardWillShow:(NSNotification *)notification
{
    keyBoardIsUp = YES ;
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        _bottomFlex.constant = 8 ;
    }];
    
    keyBoardIsUp = NO;
}
- (void)UIKeyboardDidChange:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        _bottomFlex.constant = endKeyboardRect.size.height ;
    }];
}

- (IBAction)finishBtPressedAction:(id)sender
{
    NSLog(@"完成") ;
    [self.navigationController popViewControllerAnimated:YES] ;
    [self.delegate sendContentBack:self.textView.text AndClient_aID:self.article.client_AID] ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myTitle = @"多图-子图内容页" ;
    
    self.textView.text = self.article.a_content ;
    self.textView.backgroundColor = [UIColor whiteColor] ;
    self.textView.delegate = self ;
    [self.textView becomeFirstResponder] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark - textview delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES ;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES ;
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat maxCount = self.maxCount ;
    
    if (textView.text.length > maxCount)
    {
        textView.text = [textView.text substringToIndex:maxCount] ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [XTHudManager showWordHudWithTitle:[NSString stringWithFormat:@"最多不能超过%@个字哟",@(maxCount)]] ;
            [textView resignFirstResponder] ;
        }) ;
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
