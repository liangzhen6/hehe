//
//  FriendsTableViewCell.m
//  EM_test
//
//  Created by shenzhenshihua on 16/9/9.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import "FriendsTableViewCell.h"
#import "FriendsModel.h"
@interface FriendsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *friendsLabel;

@end

@implementation FriendsTableViewCell

+ (id)friendsTableViewCellWithTableView:(UITableView *)tableView{

    NSString * className = NSStringFromClass([self class]);
    UINib * nib = [UINib nibWithNibName:className bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:className];
    
    return [tableView dequeueReusableCellWithIdentifier:className];
}


- (void)setModel:(FriendsModel *)model{
    _model = model;
    
    self.friendsLabel.text = model.friendId;

}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
