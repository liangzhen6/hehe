//
//  FriendsTableViewCell.h
//  EM_test
//
//  Created by shenzhenshihua on 16/9/9.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendsModel;
@interface FriendsTableViewCell : UITableViewCell

@property(nonatomic,strong)FriendsModel * model;

+ (id)friendsTableViewCellWithTableView:(UITableView *)tableView;

@end
