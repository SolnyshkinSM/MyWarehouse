//
//  LoginVC.h
//  MyWarehouse
//
//  Created by Administrator on 25.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AccessToken;

@interface LoginVC : UIViewController

typedef void(^LoginCompletionBlock)(AccessToken * _Nullable token);

- (instancetype)initWithCompletionBlock:(LoginCompletionBlock) completionBlock;

@end

NS_ASSUME_NONNULL_END
