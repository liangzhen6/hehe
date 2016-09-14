//
//  TWOViewController.m
//  EM_test
//
//  Created by shenzhenshihua on 16/9/7.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import "TWOViewController.h"
#import "FriendsModel.h"
#import "FriendsTableViewCell.h"
#import <EMSDK.h>
#import "TalkViewController.h"
#import "EaseUI.h"

@interface TWOViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataSource;
@end

@implementation TWOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    
    [self searchFriends];
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self searchFriends];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

- (void)searchFriends{
    
    EMError *error = nil;
    NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    NSLog(@"---%@----%@",error.errorDescription,[EMClient sharedClient].contactManager);
    if (!error) {
        NSLog(@"获取成功 -- %@",userlist);
        [self.dataSource removeAllObjects];
        for (NSString * friendsId in userlist) {
            FriendsModel * model = [FriendsModel friendsModelWithId:friendsId];
            [self.dataSource addObject:model];
        }
        
        [self.tableView reloadData];
        
    }
    
    
}

- (void)initTableView{

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    

}


#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
/**
 *  tableViewcell的分割线从头开始
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendsTableViewCell *cell = [FriendsTableViewCell friendsTableViewCellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = _dataSource[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
/*
    TalkViewController * talk = [[TalkViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:talk animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    */
    
    FriendsModel * model = _dataSource[indexPath.row];
    
    EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:model.friendId conversationType:EMConversationTypeChat];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatController animated:YES];
    self.hidesBottomBarWhenPushed = NO;

    
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }

    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
