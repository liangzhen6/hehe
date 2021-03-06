//
//  AppDelegate.m
//  EM_test
//
//  Created by shenzhenshihua on 16/9/5.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

#import <EMSDK.h>

#import "EaseUI/EaseUI.h"
#define appKey @"7215217758991#emtest"
#define apnsCert @"EMTestPush"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%@---",application);
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:appKey];
    options.apnsCertName = apnsCert;
    [[EMClient sharedClient] initializeSDKWithOptions:options];


    [[EaseSDKHelper shareHelper] easemobApplication:application didFinishLaunchingWithOptions:launchOptions appkey:appKey apnsCertName:apnsCert otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ddd" message:@"ios10退出" delegate:nil cancelButtonTitle:@"yes" otherButtonTitles:nil];
    [alert show];
    
    NSLog(@"%f",IOS_VERSION);
    if (IOS_VERSION >= 10.0) {
        UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];
        [center setDelegate:self];
        
        UNAuthorizationOptions type = UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert;
        [center requestAuthorizationWithOptions:type completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"注册成功");
            }else{
                NSLog(@"注册失败");
            }
                
        }];
        
    }else if (IOS_VERSION >= 8.0){
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
//    else{//ios8一下
//        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
//        UIRemoteNotificationTypeSound |
//        UIRemoteNotificationTypeAlert;
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
//    
//    }
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ddd" message:@"是你哈哈哈前台" delegate:nil cancelButtonTitle:@"yes" otherButtonTitles:nil];
//    [alert show];

  

//    //iOS8 注册APNS
//    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
//        [application registerForRemoteNotifications];
//        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
//        UIUserNotificationTypeSound |
//        UIUserNotificationTypeAlert;
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
//        [application registerUserNotificationSettings:settings];
//    }else{
//        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
//        UIRemoteNotificationTypeSound |
//        UIRemoteNotificationTypeAlert;
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
//    }
    
    // Override point for customization after application launch.
    return YES;
}


// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *deviceTokenSt = [[[[deviceToken description]
                                 stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                stringByReplacingOccurrencesOfString:@">" withString:@""]
                               stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceTokenSt:%@",deviceTokenSt);
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"error -- %@",error);
    
    
}



//在前台
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    
    
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
    
    
    NSLog(@"willPresentNotification:%@",notification.request.content.title);
    
    // 这里真实需要处理交互的地方
    // 获取通知所带的数据
    NSString *notMess = [notification.request.content.userInfo objectForKey:@"aps"];
    
    NSLog(@"%@--%@--",notification.request.content.subtitle,notMess);
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ddd" message:@"ios10前台" delegate:nil cancelButtonTitle:@"yes" otherButtonTitles:nil];
    [alert show];
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);

}

/*
 {
 "aps":{
 "alert":{
 "title":"Realtime Custom Push Notifications",
 "subtitle":"Now with iOS 10 support!",
 "body":"Add multimedia content to your notifications"
 },
 "sound":"default",
 "badge": 1,
 "mutable-content": 1,
 "category": "realtime",
 "data":{
 "attachment-url":"https://framework.realtime.co/blog/img/ios10-video.mp4"
 }
 }
 }
 
 {"aps":{"alert":"\\u3010\u7279\u9996\u9078\u8209\u3011\u53cd\u99c1\u300c\u5b32\u5b32\u4e0a\u5230\u500b\u9f3b\u300d\u3000\u6797\u912d\uff1a\u9999\u6e2f\u9664\u4e86\u7db2\u6c11\u9084\u6709\u5176\u4ed6\u4eba (16:45)","badge":0,"sound":"default","mutable-content":"1"},"urlProduct":"ins","urlEdition":"web_tc","urlPage":"article","urlDocIssue":"20170316","urlDocSection":"s00001","urlNodeID":"1489649871749","media":{"type":"image","url":"https://www.fotor.com/images2/features/photo_effects/e_bw.jpg"}}
 
 
 
 
 {"aps":{"alert":"\\u4e00\\u6b3e\\u6e1b\\u80a5\\u85e5\\u542b\\u672a\\u6a19\\u793a\\u6bd2\\u85e5\\u3000\\u885b\\u751f\\u7f72\\u7c72\\u52ff\\u670d\\u7528 (14:48)","badge":0,"sound":"default","mutable-content":"1"},"urlProduct":"ins","urlEdition":"web_tc","urlPage":"article","urlDocIssue":"20170207","urlDocSection":"s00001","urlNodeID":"1486448517384","image":"https://homeba.s3.amazonaws.com/__sized__/scene/2c0f3bdb7715fed7190fd87e5e5340e4-1473387950-crop-c0-5__0-5-590x442-85.jpg"}
 
 
 
 
 {"aps":{"alert":"This is some fancy message.","badge":10,"sound": "default","mutable-content":"1","category":"4921" },"image":"https://homeba.s3.amazonaws.com/__sized__/scene/2c0f3bdb7715fed7190fd87e5e5340e4-1473387950-crop-c0-5__0-5-590x442-85.jpg","type":"scene","id":"1007"}
 
 https://www.fotor.com/images2/features/photo_effects/e_bw.jpg
 
 */


- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    //在没有启动本App时，收到服务器推送消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮
    NSString *notMess = [response.notification.request.content.userInfo objectForKey:@"aps"];
    NSLog(@"didReceiveNotificationResponse:%@",response.notification.request.content.title);
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ddd" message:@"ios10后台" delegate:nil cancelButtonTitle:@"yes" otherButtonTitles:nil];
    [alert show];
    
    [UIApplication  sharedApplication].applicationIconBadgeNumber = 0;
    
    completionHandler();
//    completionHandler(UNNotificationCategoryOptionCustomDismissAction);
    //    response.notification.request.identifier
}




#pragma mark 苹果的接受推送的方法 下面的两个都有效，但是苹果建议使用第一个（<ios10版本）  ，因为下面的方法在关闭应用程序时，有推送的时候你点击进入，是不会被调用的，但是前一个可以；你只能通过程序的入口来收到推送来的消息

//远程推送APP在前台  或者是在后台再次返回前台 或者重新进入程序
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary * _Nonnull)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"didReceiveRemoteNotification:%@",userInfo);
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ddd" message:@"前台" delegate:nil cancelButtonTitle:@"yes" otherButtonTitles:nil];
    [alert show];
    
    completionHandler(UIBackgroundFetchResultNewData);
    
}



/**
 ios7以前
 app在启动，或者推到后台，但是并没有被系统杀死的时候，调用这个方法
 有缺点，
 @param application <#application description#>
 @param userInfo    <#userInfo description#>
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    if (application.applicationState == UIApplicationStateActive) {
        //应用程序在前台
        NSLog(@"%@---在前台",userInfo);
        
    }else if (application.applicationState == UIApplicationStateInactive){
        //在后台重新返回前台
        
        NSLog(@"%@---在后台但是没有被杀死",userInfo);
        
    }
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ddd" message:@"sb琴台" delegate:nil cancelButtonTitle:@"yes" otherButtonTitles:nil];
    [alert show];

    
    [UIApplication  sharedApplication].applicationIconBadgeNumber = MAX([UIApplication  sharedApplication].applicationIconBadgeNumber-1, 0);
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
        [[EMClient sharedClient] applicationDidEnterBackground:application];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
        [[EMClient sharedClient] applicationWillEnterForeground:application];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
