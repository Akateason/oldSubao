//
//  PostMainCell.h
//  SuBaoJiang
//
//  Created by apple on 15/6/26.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceHolderTextView.h"

#define TEXT_NO_TOPIC           @"#添加话题#"
#define MAX_WORDS_LENGTH        140


@protocol PostMainCellDelegate <NSObject>
- (void)talkButtonPressedWithPreContent:(NSString *)preContent ;
@end

@interface PostMainCell : UITableViewCell

@property (nonatomic, retain) id <PostMainCellDelegate> delegate ;

@property (weak, nonatomic) IBOutlet PlaceHolderTextView *textview;

@property (nonatomic, retain) UIImage   *image ;

- (void)showKeyboard ;
- (void)hideKeyboard ;
@property (nonatomic, copy) NSString    *topicStr ;

@end
