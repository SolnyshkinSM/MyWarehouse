//
//  ComingConsumptionVCCell.m
//  MyWarehouse
//
//  Created by Administrator on 20.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import "ComingConsumptionVCCell.h"

#import "MyWarehouse+CoreDataModel.h"

#import "Utils.h"

@implementation ComingConsumptionVCCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)quantityStepperAction:(UIStepper *)sender {
    [self.priceTextField resignFirstResponder];
    [self saveObject];
}

- (IBAction)priceFieldEditingDidEnd:(UITextField *)sender {
    [self saveObject];
}

#pragma mark - Action

- (void)saveObject {
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
    ComingTable *newObject = self.currentObject;
    
    newObject.quantity = self.quantityStepper.value;
    newObject.price = [[receiveCurrentNumberFormatter() numberFromString:self.priceTextField.text] floatValue];
    newObject.sum = newObject.quantity * newObject.price;
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
}

@end
