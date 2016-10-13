//
//  NotificationService.m
//  EMNotificatuin
//
//  Created by shenzhenshihua on 16/10/13.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import "NotificationService.h"
#import <UIKit/UIKit.h>
@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
//    
//    NSMutableArray *actionMutableArr = [[NSMutableArray alloc] initWithCapacity:1];
//    UNNotificationAction * actionA  =[UNNotificationAction actionWithIdentifier:@"ActionA" title:@"红色不进入" options:UNNotificationActionOptionAuthenticationRequired];
//    
//    UNNotificationAction * actionB = [UNNotificationAction actionWithIdentifier:@"ActionB" title:@"黑色不进去" options:UNNotificationActionOptionDestructive];
//    
//    UNNotificationAction * actionc = [UNNotificationAction actionWithIdentifier:@"Actionc" title:@"黑色进入" options:UNNotificationActionOptionForeground];
//    UNTextInputNotificationAction * actionD = [UNTextInputNotificationAction actionWithIdentifier:@"ActionD" title:@"写些什么吗" options:UNNotificationActionOptionDestructive textInputButtonTitle:@"send" textInputPlaceholder:@"say some thing"];
//    
//    [actionMutableArr addObjectsFromArray:@[actionA,actionB,actionc,actionD]];

    
    // Modify the notification content here...
    self.bestAttemptContent.title = [NSString stringWithFormat:@"点击查看更多内容"];
    
    NSString * attchUrl = [request.content.userInfo objectForKey:@"image"];
    //下载图片,放到本地
    UIImage * imageFromUrl = [self getImageFromURL:attchUrl];
    
    //获取documents目录
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectoryPath = [paths objectAtIndex:0];
    
    NSString * localPath = [self saveImage:imageFromUrl withFileName:@"MyImage" ofType:@"png" inDirectory:documentsDirectoryPath];
    if (localPath && ![localPath isEqualToString:@""]) {
        UNNotificationAttachment * attachment = [UNNotificationAttachment attachmentWithIdentifier:@"photo" URL:[NSURL URLWithString:[@"file://" stringByAppendingString:localPath]] options:nil error:nil];
        if (attachment) {
//            [actionMutableArr addObject:attachment];
            self.bestAttemptContent.attachments = @[attachment];
        }
    }
    
    
    
    
    
    self.contentHandler(self.bestAttemptContent);
}

- (UIImage *) getImageFromURL:(NSString *)fileURL {
    NSLog(@"执行图片下载函数");
    UIImage * result;
    //dataWithContentsOfURL方法需要https连接
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
    
}

//将所下载的图片保存到本地
-(NSString *) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    NSString *urlStr = @"";
    if ([[extension lowercaseString] isEqualToString:@"png"])
    {
        urlStr = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]];
        [UIImagePNGRepresentation(image) writeToFile:urlStr options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] ||
               [[extension lowercaseString] isEqualToString:@"jpeg"])
    {
        urlStr = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]];
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:urlStr options:NSAtomicWrite error:nil];
    } else
    {
        NSLog(@"extension error");
    }
    return urlStr;
    
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
