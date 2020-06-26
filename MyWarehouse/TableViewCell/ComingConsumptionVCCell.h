//
//  ComingConsumptionVCCell.h
//  MyWarehouse
//
//  Created by Administrator on 20.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ComingTable;

NS_ASSUME_NONNULL_BEGIN

@interface ComingConsumptionVCCell : UITableViewCell

@property(strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(strong, nonatomic) ComingTable *currentObject;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;

@property (weak, nonatomic) IBOutlet UIStepper *quantityStepper;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

- (IBAction)priceFieldEditingDidEnd:(UITextField *)sender;

- (IBAction)quantityStepperAction:(UIStepper *)sender;

@end

NS_ASSUME_NONNULL_END
