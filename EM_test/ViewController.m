//
//  ViewController.m
//  EM_test
//
//  Created by shenzhenshihua on 16/9/5.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import "ViewController.h"
#import <EMSDK.h>
#import "LoginView.h"
#import "RegisterView.h"
#import "AddFriendsViewController.h"
@interface ViewController ()<EMClientDelegate,UIAlertViewDelegate,EMContactManagerDelegate>
@property(nonatomic,copy)NSString *friends;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self registron];
// Do any additional setup after loading the view, typically from a nib.
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    //移除好友回调
//    [[EMClient sharedClient].contactManager removeDelegate:self];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:@"add" style:UIBarButtonItemStylePlain target:self action:@selector(showAddFriendsView)];
    
//    item.style =UIBarButtonSystemItemAdd;
    
    self.navigationItem.rightBarButtonItem = item;
    
    [self searchFriends];
    
}

- (void)showAddFriendsView{
    AddFriendsViewController * add = [[AddFriendsViewController alloc] init];
    
    [self.navigationController pushViewController:add animated:YES];

}

- (void)searchFriends{

    EMError *error = nil;
    NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    NSLog(@"---%@----%@",error.errorDescription,[EMClient sharedClient].contactManager);
    if (!error) {
        NSLog(@"获取成功 -- %@",userlist);
    }

}



- (IBAction)Register:(id)sender {
    RegisterView  * logon = [[[NSBundle mainBundle] loadNibNamed:@"RegisterView" owner:nil options:nil] firstObject];
    logon.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    [self.view addSubview:logon];
    
    
}


- (IBAction)Login:(id)sender {
    LoginView  * logon = [[[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:nil options:nil] firstObject];
    logon.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    [self.view addSubview:logon];
    logon.loginSuccess = ^(){
        //注册好友回调
//        [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
//        [[EMClient sharedClient].contactManager addDelegate:self];
//        [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
        [self searchFriends];
    
    };
}


/*!
 *  用户A发送加用户B为好友的申请，用户B会收到这个回调
 *
 *  @param aUsername   用户名
 *  @param aMessage    附属信息
 */
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                       message:(NSString *)aMessage{
    NSString * str = [NSString stringWithFormat:@"%@请求加你为好友？",aUsername];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"不同意" otherButtonTitles:@"同意", nil];
    alert.delegate = self;
    _friends = aUsername;
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {//不同意
            EMError *error = [[EMClient sharedClient].contactManager declineInvitationForUsername:_friends];
            if (!error) {
                NSLog(@"发送拒绝成功");
            }
        
        
        }
            break;
        case 1:
        {//同意
            EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:_friends];
            if (!error) {
                NSLog(@"发送同意成功");
            }
            
            
        }
            break;

        default:
            break;
    }

}

/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B同意后，用户A会收到这个回调
 */
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername{
    NSString * hehe = [NSString stringWithFormat:@"%@同意了你的好友请求",aUsername];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:hehe delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];


}

/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B拒绝后，用户A会收到这个回调
 */
- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername{

    NSString * hehe = [NSString stringWithFormat:@"%@拒绝了你的好友请求",aUsername];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:hehe delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
