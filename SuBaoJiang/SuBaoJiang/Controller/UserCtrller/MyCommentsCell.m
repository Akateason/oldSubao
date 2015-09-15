//
//  MyCommentsCell.m
//  SuBaoJiang
//
//  Created by apple on 15/6/16.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "MyCommentsCell.h"
#import "MyCmtCell.h"
#import "UserCenterController.h"

@interface MyCommentsCell ()
@property (weak, nonatomic) IBOutlet UITableView *table;
@end

@implementation MyCommentsCell

- (void)setCmtList:(NSMutableArray *)cmtList
{
    _cmtList = cmtList ;
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_table reloadData] ;
    }) ;

}


- (void)awakeFromNib {
    // Initialization code
    
    _table.delegate = self ;
    _table.dataSource = self ;
    _table.separatorColor = COLOR_TABLE_SEP ;
    _table.backgroundColor = COLOR_BACKGROUND ;
    _table.scrollEnabled = NO ;
//    _table.rowHeight = UITableViewAutomaticDimension;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark --
#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1 ; // user info + content ;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cmtList count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString  *CellIdentiferId = @"MyCmtCell";
    MyCmtCell *cell = [_table dequeueReusableCellWithIdentifier:CellIdentiferId] ;
    if (!cell)
    {
        [_table registerNib:[UINib nibWithNibName:CellIdentiferId bundle:nil] forCellReuseIdentifier:CellIdentiferId];
        cell = [_table dequeueReusableCellWithIdentifier:CellIdentiferId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.cmt = _cmtList[indexPath.row] ;
    cell.bt_head.userInteractionEnabled = NO ;
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return [MyCmtCell calculateHeightWithCmt:((ArticleComment *)_cmtList[indexPath.row]).c_content] ;
    
}



#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.userInteractionEnabled = NO ;
    
    ArticleComment *cmt = _cmtList[indexPath.row] ;
    
    [self.delegate jump2Article:cmt.a_id] ;
    
    tableView.userInteractionEnabled = YES ;
}









@end
