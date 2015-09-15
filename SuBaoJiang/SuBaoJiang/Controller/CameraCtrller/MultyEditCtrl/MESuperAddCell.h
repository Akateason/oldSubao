//
//  MESuperAddCell.h
//  subao
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MESuperAddCellDelegate <NSObject>
- (void)superAddCellAddingBtClick ;
@end

@interface MESuperAddCell : UITableViewCell
@property (nonatomic,retain) id <MESuperAddCellDelegate> delegate ;
@end
