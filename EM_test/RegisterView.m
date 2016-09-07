//
//  RegisterView.m
//  EM_test
//
//  Created by shenzhenshihua on 16/9/7.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import "RegisterView.h"
#import <EMSDK.h>
@implementation RegisterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
- (IBAction)RegisterAction:(id)sender {
    
    EMError *error = [[EMClient sharedClient] registerWithUsername:_Username.text password:_Password.text];
    if (error==nil) {
        NSLog(@"注册成功");
        [self removeFromSuperview];
    }

    
}

@end
