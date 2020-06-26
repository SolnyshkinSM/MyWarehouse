//
//  User.m
//  MyWarehouse
//
//  Created by Administrator on 25.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithServerResponse:(NSDictionary *) responseObject {
    
    if (self) {
        
        self.userID = [responseObject objectForKey:@"id"];
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName = [responseObject objectForKey:@"last_name"];
        
        NSNumber *onlineNumber = [responseObject objectForKey:@"online"];
        self.online = [onlineNumber doubleValue];
        
        NSString *urlString = [responseObject objectForKey:@"photo_200_orig"];
        self.imageUrl = [NSURL URLWithString:urlString];
        
    }
    
    return self;
    
}

@end
