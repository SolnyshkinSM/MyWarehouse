//
//  Utils.h
//  MyWarehouse
//
//  Created by Administrator on 12.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIAlertController;
@class UITableViewController;
@class UITabBarController;
@class UIColor;

typedef enum {
    TypeObjectModelCompany      = 1 << 0,
    TypeObjectModelClient       = 1 << 1,
    TypeObjectModelStorage      = 1 << 2,
    TypeObjectModelUnits        = 1 << 3,
    TypeObjectModelComing       = 1 << 4,
    TypeObjectModelConsumption  = 1 << 5,
} TypeObjectModel;

UIAlertController *receiveAlert(NSString *title, NSString *message);

UITableViewController * receiveTableViewController(NSString *identifier);

NSNumberFormatter * receiveCurrentNumberFormatter(void);

NSDateFormatter * receiveCurrentDateFormatter(void);

UITabBarController * receiveCurrentTabBarController(void);

UIColor * receiveRandomColor(void);
