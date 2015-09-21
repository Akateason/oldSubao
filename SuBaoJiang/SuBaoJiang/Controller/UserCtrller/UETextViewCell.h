//
//  UETextViewCell.h
//  subao
//
//  Created by TuTu on 15/9/21.
//  Copyright © 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceHolderTextView.h"

@interface UETextViewCell : UITableViewCell
@property (nonatomic) NSInteger maxOverFlowCount ;
@property (nonatomic,copy) NSString *strPlaceHolder ;

@property (weak, nonatomic) IBOutlet PlaceHolderTextView *textView;
@end
