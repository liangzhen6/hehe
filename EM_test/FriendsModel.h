//
//  FriendsModel.h
//  EM_test
//
//  Created by shenzhenshihua on 16/9/9.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendsModel : NSObject
@property(nonatomic,copy)NSString * friendId;

+ (id)friendsModelWithId:(NSString *)string;

+ (id)fridensModelWithDict:(NSDictionary *)dict;


@end
