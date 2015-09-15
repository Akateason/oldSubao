//
//  NoteAlamCell.h
//  SuBaoJiang
//
//  Created by apple on 15/7/31.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TYPE_NoteAlam) {
    typeComment = 1 ,
    typePraise
} ;

@interface NoteAlamCell : UITableViewCell
@property (nonatomic) TYPE_NoteAlam type ;
@property (nonatomic) NSInteger noteCount ;
@end
