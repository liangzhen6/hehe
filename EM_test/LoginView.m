//
//  LoginView.m
//  EM_test
//
//  Created by shenzhenshihua on 16/9/7.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import "LoginView.h"
#import <EMSDK.h>
#import "user.h"
@implementation LoginView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)loginAction:(id)sender {
    
//    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    
    EMError *error = [[EMClient sharedClient] loginWithUsername:_Username.text password:_password.text];
    NSLog(@"%@",error.errorDescription);
    if (!error)
    {
        user * use = [user shareUser];
        use.useID = _Username.text;
        use.password = _password.text;
        NSLog(@"登录成功");
        [[EMClient sharedClient].options setIsAutoLogin:YES];
        [self removeFromSuperview];
        if (self.loginSuccess) {
            self.loginSuccess();
        }
    }

 
}
- (IBAction)logout:(id)sender {
    
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        NSLog(@"退出成功");
    }
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
/*!
 *  自动登录返回结果
 *
 *  @param aError 错误信息
 */
- (void)didAutoLoginWithError:(EMError *)aError{
    NSLog(@"自动登录出错：%@",aError);
    
}
/*!
 *  SDK连接服务器的状态变化时会接收到该回调
 *
 *  有以下几种情况，会引起该方法的调用：
 *  1. 登录成功后，手机无法上网时，会调用该回调
 *  2. 登录成功后，网络状态变化时，会调用该回调
 *
 *  @param aConnectionState 当前状态
 */
- (void)didConnectionStateChanged:(EMConnectionState)aConnectionState{
    NSLog(@"重新连接");
    
}

/*!
 *  当前登录账号在其它设备登录时会接收到该回调
 */
- (void)didLoginFromOtherDevice{
    NSLog(@"当前登录账号在其它设备登录时会接收到该回调");
}

/*!
 *  当前登录账号已经被从服务器端删除时会收到该回调
 */
- (void)didRemovedFromServer{
    NSLog(@"当前登录账号已经被从服务器端删除时会收到该回调");
    
    
}

@end
