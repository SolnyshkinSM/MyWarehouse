//
//  CompanyClientAddTVC.h
//  MyWarehouse
//
//  Created by Administrator on 13.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Utils.h"

@class MKMapView;

NS_ASSUME_NONNULL_BEGIN

@interface CompanyClientAddTVC : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) id currentObject;
@property (assign, nonatomic) TypeObjectModel typeObjectModel;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)okAction:(UIButton *)sender;
- (IBAction)markAction:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
