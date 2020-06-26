//
//  User.h
//  MyWarehouse
//
//  Created by Administrator on 25.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSURL *imageUrl;
@property (assign, nonatomic) double online;

- (instancetype)initWithServerResponse:(NSDictionary *) responseObject;

@end

NS_ASSUME_NONNULL_END
