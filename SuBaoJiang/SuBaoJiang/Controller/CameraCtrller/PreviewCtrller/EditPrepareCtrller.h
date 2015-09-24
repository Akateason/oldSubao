//
//  CuttingCtrller.h
//  subao
//
//  Created by apple on 15/8/4.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "RootCtrl.h"

@protocol EditPrepareCtrllerDelegate <NSObject>
- (void)editFinishCallBackWithImage:(UIImage *)image ;
@end

@interface EditPrepareCtrller : RootCtrl
@property (nonatomic,copy)   NSString *topicStr ;
@property (nonatomic,strong) UIImage  *imgSend ;
@property (nonatomic)        BOOL     isEditingPicture ;
@property (nonatomic,weak)   id <EditPrepareCtrllerDelegate> delegate ;

+ (void)jump2EditPrepareCtrllerFromCtrller:(UIViewController *)ctrller
                                  AndImage:(UIImage *)imageResource
                                 isEditing:(BOOL)isEdit ;
@end
