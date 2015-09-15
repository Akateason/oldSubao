//
//  TopicInputVIew.h
//  SuBaoJiang
//
//  Created by apple on 15/7/2.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TopicInputVIewDelegate <NSObject>
- (void)newTopicConfirmed:(NSString *)topicStr ;
@end

@interface TopicInputVIew : UIView <UITextFieldDelegate>
@property (nonatomic,retain) id <TopicInputVIewDelegate> delegate ;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *lb_symbol;
@property (weak, nonatomic) IBOutlet UITextField *textfield;

@end
