//
//  NotificationViewController.m
//  EMNitificationUI
//
//  Created by shenzhenshihua on 16/10/13.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

#import "UIImageView+EMWebCache.h"

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//      self.preferredContentSize = CGSizeMake(CGRectGetWidth(self.view.frame), 500);
    // Do any required interface initialization here.
}

- (void)didReceiveNotification:(UNNotification *)notification {
    self.label.text = notification.request.content.body;
//    NSString * attchUrl = [notification.request.content.userInfo objectForKey:@"image"];
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:attchUrl]];
        
    UNNotificationContent * content = notification.request.content;
    UNNotificationAttachment * attachment = content.attachments.firstObject;
    if (attachment.URL.startAccessingSecurityScopedResource) {
        self.imageView.image = [UIImage imageWithContentsOfFile:attachment.URL.path];
    }
    
}

@end
