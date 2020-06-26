//
//  ServerManager.h
//  MyWarehouse
//
//  Created by Administrator on 25.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@class UIImage;

NS_ASSUME_NONNULL_BEGIN

@interface ServerManager : NSObject

@property (strong, nonatomic) User *currentUser;

+ (ServerManager *)sharedManager;

- (void)authorizeUser:(void(^)(User *user)) completion;

- (void)postText:(NSString *)text
           image:(UIImage *)image
     onGroupWall:(NSString *)groupID
       onSuccess:(void(^)(id result)) success
       onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;


@end

NS_ASSUME_NONNULL_END
