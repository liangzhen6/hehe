//
//  ViewController.m
//  EM_test
//
//  Created by shenzhenshihua on 16/9/5.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <EMSDK.h>
#import "LoginView.h"
#import "RegisterView.h"
#import "AddFriendsViewController.h"
@interface ViewController ()<EMClientDelegate,UIAlertViewDelegate,EMContactManagerDelegate,EMChatManagerDelegate>
@property(nonatomic,copy)NSString *friends;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self registron];
// Do any additional setup after loading the view, typically from a nib.
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    //注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:@"add" style:UIBarButtonItemStylePlain target:self action:@selector(showAddFriendsView)];
    
//    item.style =UIBarButtonSystemItemAdd;
    
    self.navigationItem.rightBarButtonItem = item;
    
    [self searchFriends];
    
}

- (void)showAddFriendsView{
    AddFriendsViewController * add = [[AddFriendsViewController alloc] init];
    
    [self.navigationController pushViewController:add animated:YES];

}
- (IBAction)pushAction:(id)sender {
    
    
    
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.body = @"Hello,world!";
    content.title = @"通知";
    content.subtitle = @"text";

    content.badge = @1;
    /*
     NSString * imagePath = [[NSBundle mainBundle] pathForResource:@"jump_icon-60" ofType:@"png"];
     if (imagePath) {//@"imageAttachment"
     NSError * error = nil;
     UNNotificationAttachment * imageActionment = [UNNotificationAttachment attachmentWithIdentifier:@"imageAttachment" URL:[NSURL fileURLWithPath:imagePath] options:nil error:&error];
     if (imageActionment) {
     //这里attachments虽然是数组但是，但是只会取lastObject
     content.attachments = @[imageActionment];
     }
     
     }*/
    
    NSString *videoPatch = [[NSBundle mainBundle] pathForResource:@"WhatsApp" ofType:@".mp4"];
    if (videoPatch) {
        NSError * error = nil;
        
        UNNotificationAttachment * videoActtachment = [UNNotificationAttachment attachmentWithIdentifier:@"videoAttachment4" URL:[NSURL fileURLWithPath:videoPatch] options:nil error:&error];
        if (videoActtachment) {
            content.attachments = @[videoActtachment];
        }
        
    }
    
    NSMutableArray *actionMutableArr = [[NSMutableArray alloc] initWithCapacity:1];
    UNNotificationAction * actionA  =[UNNotificationAction actionWithIdentifier:@"ActionA" title:@"红色不进入" options:UNNotificationActionOptionAuthenticationRequired];
    
    UNNotificationAction * actionB = [UNNotificationAction actionWithIdentifier:@"ActionB" title:@"黑色不进去" options:UNNotificationActionOptionDestructive];
    
    UNNotificationAction * actionc = [UNNotificationAction actionWithIdentifier:@"Actionc" title:@"黑色进入" options:UNNotificationActionOptionForeground];
    
    [actionMutableArr addObjectsFromArray:@[actionA,actionB,actionc]];
    
    if (actionMutableArr.count) {
        UNNotificationCategory * notficationCategory = [UNNotificationCategory categoryWithIdentifier:@"categoryNoOperationAction" actions:actionMutableArr intentIdentifiers:@[@"ActionA",@"ActionB"] options:UNNotificationCategoryOptionCustomDismissAction];
        
        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObject:notficationCategory]];
        content.categoryIdentifier = @"categoryNoOperationAction";
        
        
    }
    

    
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5
                                                                                                    repeats:NO];
    NSString* requestIdentifer = @"Request";
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:requestIdentifer
                                                                          content:content
                                                                          trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request
                                                           withCompletionHandler:^(NSError * _Nullable error) {
                                                               NSLog(@"Error%@", error);
                                                           }];

    
    
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


#pragma mark    消息
/*!
 @method
 @brief 接收到一条及以上非cmd消息
 */
- (void)didReceiveMessages:(NSArray *)aMessages{

    NSLog(@"----%@#",aMessages);

}

/*!
 @method
 @brief 接收到一条及以上cmd消息
 */
- (void)didReceiveCmdMessages:(NSArray *)aCmdMessages{
     NSLog(@"----%@#",aCmdMessages);
    

}
/**
 *  重写dealloc；
 */
- (void)dealloc{
    
    //移除好友回调
   [[EMClient sharedClient].contactManager removeDelegate:self];
    
    //移除消息回调
    [[EMClient sharedClient].chatManager removeDelegate:self];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
