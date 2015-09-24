//
//  MESuperArticleCell.h
//  subao
//
//  Created by apple on 15/8/20.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Article ;

@protocol MESuperArticleCellDelegate <NSObject>
- (void)talkButtonPressedWithPreContent:(NSString *)preContent ;
- (void)mesuperArticleContentTextviewPressed ;
- (void)mainTitleChanged:(NSString *)title ;
- (void)changeImage ;
- (void)editImage ;
@end

@interface MESuperArticleCell : UITableViewCell

@property (nonatomic, weak)     id <MESuperArticleCellDelegate> delegate ;
@property (nonatomic, retain)   Article     *articleSuper ;
@property (nonatomic, copy)     NSString    *topicStr ;
- (void)mainTitleAnimateAction ;

@end
