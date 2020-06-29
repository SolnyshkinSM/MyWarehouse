//
//  UserProtocol.h
//  MyWarehouse
//
//  Created by Administrator on 29.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UserProtocol <NSObject>

@required
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;

@optional
@property (strong, nonatomic) NSURL *imageUrl;
@property (assign, nonatomic) double online;

@required
- (instancetype)initWithServerResponse:(NSDictionary *) responseObject;

@end

NS_ASSUME_NONNULL_END
