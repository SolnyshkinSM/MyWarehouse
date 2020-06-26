//
//  ServerManager.m
//  MyWarehouse
//
//  Created by Administrator on 25.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import "ServerManager.h"

#import "AFNetworking.h"

#import "AccessToken.h"
#import "User.h"

#import "LoginVC.h"

@interface ServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (strong, nonatomic) AccessToken *accessToken;

@end

@implementation ServerManager

+ (ServerManager *)sharedManager {
    
    static ServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    
    return manager;
    
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        NSURL *baseUrl = [NSURL URLWithString:@"https://api.vk.com/method/"];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
        
    }
    
    return self;
    
}

- (void)authorizeUser:(void(^)(User *user)) completion {
    
    LoginVC *loginViewController = [[LoginVC alloc] initWithCompletionBlock:^(AccessToken * _Nullable token) {
        
        self.accessToken = token;
        
        if (token) {
            
            [self getUser:self.accessToken.userID
                onSuccess:^(User * _Nonnull user) {
                if (completion) {
                    completion(user);
                }
            } onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
                if (completion) {
                    completion(nil);
                }
            }];
        } else {
            if (completion) {
                completion(nil);
            }
        }
        
    }];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    
    UIViewController *mainController = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    
    [mainController presentViewController:navigationController animated:YES completion:nil];
    
}

- (void)getUser:(NSString *) userID onSuccess:(void(^)(User *user)) success
      onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userID,                     @"user_ids",
                                @"online, photo_200_orig",  @"fields",
                                @"nom",                     @"name_case",
                                self.accessToken.token,     @"access_token",
                                @"5.107",                   @"v", nil];
    
    [self.sessionManager GET:@"users.get"
                  parameters:parameters
                     headers:nil
                    progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //NSLog(@"JSON: %@", responseObject);
        
        NSArray *dictsArray = [responseObject objectForKey:@"response"];
        
        if ([dictsArray count] > 0) {
            
            User *user = [[User alloc] initWithServerResponse:[dictsArray firstObject]];
            
            self.currentUser = user;
            
            if (success) {
                success(user);
            }
            
        } else {
            if (failure) {
                failure(nil, 400);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"Unresolved error %@", error);
        if (failure) {
            failure(error, 500);
        }
    }];
    
}

- (void)postText:(NSString *) text
           image:(UIImage *)image
     onGroupWall:(NSString *) groupID
       onSuccess:(void(^)(id result)) success
       onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
       
    if (image) {
        
        NSDictionary *paramDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                         groupID,                   @"group_id",
                                         @"5.107",                  @"v",
                                         self.accessToken.token,    @"access_token", nil];
        
        [self.sessionManager GET:@"photos.getWallUploadServer"
                      parameters:paramDictionary
                         headers:nil
                        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //NSLog(@"JSON: %@", responseObject);
            
            NSDictionary *objects = [responseObject objectForKey:@"response"];
            
            NSString *upload_url = [objects objectForKey:@"upload_url"];
            NSString *user_id = [objects objectForKey:@"user_id"];
            
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            
            [manager POST:upload_url
               parameters:nil
                  headers:nil
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                [formData appendPartWithFileData:imageData name:@"file1" fileName:@"file1.png" mimeType:@"image/jpeg"];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                //NSLog(@"Success: %@", responseObject);
                
                NSString *hash = [responseObject objectForKey:@"hash"];
                NSString *photo = [responseObject objectForKey:@"photo"];
                NSString *server = [responseObject objectForKey:@"server"];
                
                NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                       user_id,                 @"user_id",
                                       groupID,                 @"group_id",
                                       server,                  @"server",
                                       photo,                   @"photo",
                                       hash,                    @"hash",
                                       @"5.107",                @"v",
                                       self.accessToken.token,  @"access_token", nil];
                
                [self.sessionManager GET:@"photos.saveWallPhoto"
                              parameters:param
                                 headers:nil
                                progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    //NSLog(@"Success: %@", responseObject);
                    
                    NSArray *objects = [responseObject objectForKey:@"response"];
                    NSDictionary *dict = [objects firstObject];
                    NSString *owner_id = [dict objectForKey:@"owner_id"];
                    NSString *media_id = [dict objectForKey:@"id"];
                    
                    NSString *attachments = [NSString stringWithFormat:@"photo%@_%@",owner_id,media_id];
                    
                    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                                            groupID,                @"owner_id",
                                            text,                   @"message",
                                            attachments,            @"attachments",
                                            self.accessToken.token, @"access_token",
                                            @"5.107",               @"v", nil];
                    
                    [self.sessionManager POST:@"wall.post"
                                   parameters:params
                                      headers:nil
                                     progress:^(NSProgress * _Nonnull uploadProgress) {
                        
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        
                        //NSLog(@"JSON: %@", responseObject);
                        if (success) {
                            success(responseObject);
                        }
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                        //NSLog(@"Error: %@", error);
                        if (failure) {
                            failure(error, 500);
                        }
                        
                    }];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
              
        
    } else {
        
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    groupID,                @"owner_id",
                                    text,                   @"message",
                                    self.accessToken.token, @"access_token",
                                    @"5.107",               @"v", nil];
        
        [self.sessionManager POST:@"wall.post"
                       parameters:parameters
                          headers:nil
                         progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //NSLog(@"JSON: %@", responseObject);
            if (success) {
                success(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            //NSLog(@"Unresolved error %@", error);
            if (failure) {
                failure(error, 500);
            }
            
        }];
    }
    
}

@end
