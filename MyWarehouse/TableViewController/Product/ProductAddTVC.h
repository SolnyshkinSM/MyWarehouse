//
//  ProductAddTVC.h
//  MyWarehouse
//
//  Created by Administrator on 16.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Utils.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductAddTVC : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) id currentObject;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *unitsTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *productServiceSegmentedControl;

- (IBAction)okAction:(UIButton *)sender;

- (void)selectedValueDelegateTVC:(id)object;

@end

NS_ASSUME_NONNULL_END
