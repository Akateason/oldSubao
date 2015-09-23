//
//  WordSendView.h
//  SuBaoJiang
//
//  Created by apple on 15/6/3.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlywordInputView.h"
#import "Article.h"
#import "ArticleComment.h"
#import "FlywordLabel.h"


@protocol WordSendViewDelegate <NSObject>
// login
- (void)goToLogin ;
// send cmt or reply
- (BOOL)sendCommentButtonPressedCallWithContent:(NSString *)content
                                AndWithColorStr:(NSString *)colorStr
                                 AndWithSizeStr:(NSString *)sizeStr
                             AndWithPositionStr:(NSString *)positionStr ;
@end

@interface WordSendView : UIView
// properties
@property (nonatomic,weak) id <WordSendViewDelegate> delegate ;
@property (nonatomic,weak) ArticleComment *comment ;
// views
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *btSend;
@property (weak, nonatomic) IBOutlet FlywordLabel *lb_placeholder;
@property (strong, nonatomic) FlywordInputView *flywordInputView ;
// func
- (void)resetToOrigin ;
- (void)reloadPlaceHolder ;
@end
