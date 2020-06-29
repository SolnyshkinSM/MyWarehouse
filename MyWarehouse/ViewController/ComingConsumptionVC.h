//
//  ComingConsumptionVC.h
//  MyWarehouse
//
//  Created by Administrator on 17.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyWarehouse+CoreDataModel.h"

#import "Utils.h"

extern NSString* _Nullable const ComingConsumptionVCAddNewObjectDidChangeNotification;
extern NSString* _Nullable const ComingConsumptionVCAddNewObjectUserInfoKey;

NS_ASSUME_NONNULL_BEGIN

@interface ComingConsumptionVC : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) id currentObject;
@property (assign, nonatomic) TypeObjectModel typeObjectModel;

@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UILabel *totalSumLabel;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *clientTextField;
@property (weak, nonatomic) IBOutlet UITextField *storageTextField;

@property (weak, nonatomic) IBOutlet UINavigationBar *productsBar;
@property (weak, nonatomic) IBOutlet UITableView *productsTV;

- (IBAction)okAction:(UIButton *)sender;

- (void)selectedValueDelegateTVC:(id)object;

@end

NS_ASSUME_NONNULL_END
