//
//  DiagramVC.h
//  MyWarehouse
//
//  Created by Administrator on 21.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Utils.h"

NS_ASSUME_NONNULL_BEGIN

@interface DiagramVC : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (assign, nonatomic) TypeObjectModel typeObjectModel;

@end

NS_ASSUME_NONNULL_END
