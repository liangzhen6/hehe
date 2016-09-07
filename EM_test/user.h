//
//  user.h
//  EM_test
//
//  Created by shenzhenshihua on 16/9/7.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface user : NSObject

@property(nonatomic,copy)NSString * useID;

@property(nonatomic,copy)NSString * password;

+ (id)shareUser;

@end
