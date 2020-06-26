//
//  StorageUnitsAddTVC.h
//  MyWarehouse
//
//  Created by Administrator on 15.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Utils.h"

NS_ASSUME_NONNULL_BEGIN

@interface StorageUnitsAddTVC : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) id currentObject;
@property (assign, nonatomic) TypeObjectModel typeObjectModel;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

- (IBAction)okAction:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
