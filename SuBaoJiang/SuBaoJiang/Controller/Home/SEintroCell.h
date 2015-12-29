//
//  SEintroCell.h
//  SuBaoJiang
//
//  Created by TuTu on 15/7/31.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SEintroCellDelegate <NSObject>
- (void)topicDetailImageFetchingFinished ; // need to calculate height in super controller .
@end

@interface SEintroCell : UITableViewCell

@property (nonatomic,weak) id <SEintroCellDelegate> delegate ;
@property (nonatomic,copy) NSString *strImg ;

@end
