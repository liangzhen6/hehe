//
//  AddFriendsViewController.m
//  EM_test
//
//  Created by shenzhenshihua on 16/9/7.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import "AddFriendsViewController.h"
#import <EMSDK.h>
@interface AddFriendsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *useid;
@property (weak, nonatomic) IBOutlet UITextField *message;

@end

@implementation AddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)sendAction:(id)sender {
    EMError *error = [[EMClient sharedClient].contactManager addContact:_useid.text message:_message.text];
    NSLog(@"---%@----%@",error.errorDescription,[EMClient sharedClient].contactManager);
    if (!error) {
        NSLog(@"添加成功");
     
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加发出成功" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
