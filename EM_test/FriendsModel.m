//
//  FriendsModel.m
//  EM_test
//
//  Created by shenzhenshihua on 16/9/9.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import "FriendsModel.h"

@implementation FriendsModel

+ (id)friendsModelWithId:(NSString *)string{
    FriendsModel * model = [[self alloc] init];
    if (string) {
        model.friendId = string;
    }
    
    return model;
}

+ (id)fridensModelWithDict:(NSDictionary *)dict{

    return [[self alloc] init];
}
@end
