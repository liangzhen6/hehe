//
//  user.m
//  EM_test
//
//  Created by shenzhenshihua on 16/9/7.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import "user.h"
@implementation user

+ (id)shareUser{

    static user *use;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        use  = [[user alloc] init];
    });

    return use;

}


@end
