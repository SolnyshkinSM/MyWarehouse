//
//  ComingConsumptionVC.m
//  MyWarehouse
//
//  Created by Administrator on 17.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import "ComingConsumptionVC.h"

#import "CompanyClientTVC.h"
#import "StorageUnitsTVC.h"
#import "ProductTVC.h"
#import "ComingConsumptionVCCell.h"

@interface ComingConsumptionVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) Company *selectedCompany;
@property (strong, nonatomic) Client *selectedClient;
@property (strong, nonatomic) Storage *selectedStorage;

@end

@implementation ComingConsumptionVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configureView];
    
}

#pragma mark - Configure

- (void)configureView {
        
    if (self.currentObject) {
        
        Coming *coming = (Coming *)self.currentObject;
        
        self.numberTextField.text = coming.number;
        self.dateTextField.text = [receiveCurrentDateFormatter() stringFromDate:coming.date];
        self.totalSumLabel.text = [receiveCurrentNumberFormatter() stringFromNumber:@(coming.totalSum)];
        self.selectedCompany = coming.company;
        self.companyTextField.text = coming.company.name;
        self.selectedClient = coming.client;
        self.clientTextField.text = coming.client.name;
        self.selectedStorage = coming.storage;
        self.storageTextField.text = coming.storage.name;
        
    } else {
        
        self.dateTextField.text = [receiveCurrentDateFormatter() stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        self.numberTextField.text = [self receiveRelevantNumber];
        
    }
    
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addNewObject:)];
    self.productsBar.topItem.rightBarButtonItem = addItem;
    
    [self countUpTotalSum];
        
}


#pragma mark - Action

-(void)addNewObject:(UIBarButtonItem *)sender {
    
   ProductTVC *productTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductTVC"];
   productTVC.delegateVC = self;
   [self.navigationController presentViewController:productTVC animated:YES completion:nil];
    
}

- (IBAction)okAction:(UIButton *)sender {
    
    [self SaveCurrentNewObject];
        
    [self.navigationController popViewControllerAnimated:YES];
        
}

- (void)SaveCurrentNewObject {
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
    id newObject = nil;
    if (self.currentObject) {
        newObject = self.currentObject;
    } else {
        switch (self.typeObjectModel) {
            case TypeObjectModelComing:
                newObject = [[Coming alloc] initWithContext:context];
                break;
            case TypeObjectModelConsumption:
                   newObject = [[Consumption alloc] initWithContext:context];
                break;
            default:
                break;
        }
    }
      
    [newObject setValue:self.numberTextField.text forKey:@"number"];
    [newObject setValue:[receiveCurrentDateFormatter() dateFromString:self.dateTextField.text] forKey:@"date"];
    [newObject setValue:self.selectedCompany forKey:@"company"];
    [newObject setValue:self.selectedClient forKey:@"client"];
    [newObject setValue:self.selectedStorage forKey:@"storage"];
    [newObject setValue:[receiveCurrentNumberFormatter() numberFromString:self.totalSumLabel.text] forKey:@"totalSum"];
    
    self.currentObject = newObject;
        
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
}

-(void)changeDatePicker:(UIDatePicker*)sender {
    self.dateTextField.text = [receiveCurrentDateFormatter() stringFromDate:sender.date];
}

- (void)selectedValueDelegateTVC:(id)object {
        
    if ([object isKindOfClass:[Company class]]) {
        self.selectedCompany = object;
        self.companyTextField.text = [(Company *)object name];
    } else if ([object isKindOfClass:[Client class]]) {
        self.selectedClient = object;
        self.clientTextField.text = [(Client *)object name];
    } else if ([object isKindOfClass:[Storage class]]) {
        self.selectedStorage = object;
        self.storageTextField.text = [(Storage *)object name];
    } else if ([object isKindOfClass:[Product class]]) {
        
        if (!self.currentObject) {
            [self SaveCurrentNewObject];
            _fetchedResultsController = nil;
            [self.productsTV reloadData];
        }
        
        NSManagedObjectContext *context = self.managedObjectContext;
       
        id newObject = nil;
        switch (self.typeObjectModel) {
            case TypeObjectModelComing:
                newObject = [[ComingTable alloc] initWithContext:context];
                break;
            case TypeObjectModelConsumption:
                newObject = [[ConsumptionTable alloc] initWithContext:context];
                break;
            default:
                break;
        }
        
        [newObject setValue:self.currentObject forKey:@"owner"];
        [newObject setValue:object forKey:@"product"];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
        
        _fetchedResultsController = nil;
        [self.productsTV reloadData];
                
    }
    
}

- (NSString *)receiveRelevantNumber {
    
    static NSInteger lengthNumber = 6;
    
    static NSString *relevantNumber = @"";
    
    NSFetchRequest *fetchRequest = nil;
    switch (self.typeObjectModel) {
        case TypeObjectModelComing:
            fetchRequest = Coming.fetchRequest;
            break;
        case TypeObjectModelConsumption:
            fetchRequest = Consumption.fetchRequest;
            break;
        default:
            break;
    }
    
    [fetchRequest setResultType:NSCountResultType];
        
    NSError *error = nil;
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Unresolved error %@, %@", error, error.localizedDescription);
        return relevantNumber;
    }
    
    NSInteger countItem = [[resultArray firstObject] integerValue] + 1;
    NSString *countItemString = [NSString stringWithFormat:@"%ld", (long)countItem];
    
    while ([relevantNumber length] < lengthNumber - [countItemString length]) {
        relevantNumber = [relevantNumber stringByAppendingString:@"0"];
    }
        
    return [relevantNumber stringByAppendingString:countItemString];
    
}

-(void)configureCell:(ComingConsumptionVCCell *)cell withObject:(id)object {
 
    cell.currentObject = object;
    cell.sumLabel.text = [receiveCurrentNumberFormatter() stringFromNumber:@([object sum])];
    cell.quantityStepper.value = [object quantity];
    cell.quantityLabel.text = [receiveCurrentNumberFormatter() stringFromNumber:@([object quantity])];
    cell.priceTextField.text = [receiveCurrentNumberFormatter() stringFromNumber:@([object price])];
        
    Product *product = [object product];
    cell.nameLabel.text = product.name;
    cell.logoImageView.image = [UIImage imageWithData:product.logo];
        
}

- (void)countUpTotalSum {
    
    double totalSum = 0;
    NSArray *resultObjects = [self.fetchedResultsController fetchedObjects];
    for (ComingTable *comitTable in resultObjects) {
        totalSum += comitTable.sum;
    }
    
    self.totalSumLabel.text = [receiveCurrentNumberFormatter() stringFromNumber:@(totalSum)];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.dateTextField]) {
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = [UIColor whiteColor];
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:self.view.bounds];
        datePicker.datePickerMode = UIDatePickerModeDate;
        if (self.currentObject) {
            datePicker.date = [(Coming *)self.currentObject date];
        }
        [datePicker addTarget:self action:@selector(changeDatePicker:) forControlEvents:UIControlEventValueChanged];
        [view addSubview:datePicker];
        
        UIViewController *viewController = [[UIViewController alloc] init];
        viewController.view = view;
        [self.navigationController showViewController:viewController sender:nil];
        
        return NO;
        
    } else if ([textField isEqual:self.companyTextField] || [textField isEqual:self.clientTextField]) {
        
        CompanyClientTVC *companyClientTVC = [[CompanyClientTVC alloc] init];
        companyClientTVC.typeObjectModel = [textField isEqual:self.companyTextField] ? TypeObjectModelCompany : TypeObjectModelClient;
        companyClientTVC.delegateVC = self;
        [self.navigationController presentViewController:companyClientTVC animated:YES completion:nil];
        
        return NO;
        
    } else if ([textField isEqual:self.storageTextField]) {
        
        StorageUnitsTVC *storageUnitsTVC = [[StorageUnitsTVC alloc] init];
        storageUnitsTVC.typeObjectModel = TypeObjectModelStorage;
        storageUnitsTVC.delegateVC = self;
        [self.navigationController presentViewController:storageUnitsTVC animated:YES completion:nil];
        
        return NO;
        
    }
    
    return YES;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self receiveSectionInfo:section] numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self receiveSectionInfo:section].name;
}

- (id <NSFetchedResultsSectionInfo>)receiveSectionInfo:(NSInteger)section {
    return [self.fetchedResultsController sections][section];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSManagedObjectContext *context = self.fetchedResultsController.managedObjectContext;
        
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
        
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifierCell = @"ComingVCCell";
    
    ComingConsumptionVCCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    
    cell.managedObjectContext = self.fetchedResultsController.managedObjectContext;
    
    id object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self configureCell:cell withObject:object];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 118.f;
}

#pragma mark - NSFetchedResultsControllerDelegate

@synthesize fetchedResultsController = _fetchedResultsController;

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = nil;
    switch (self.typeObjectModel) {
        case TypeObjectModelComing:
            fetchRequest = ComingTable.fetchRequest;
            break;
        case TypeObjectModelConsumption:
            fetchRequest = ConsumptionTable.fetchRequest;
            break;
        default:
            break;
    }
        
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"product.name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"owner = %@", self.currentObject];
    [fetchRequest setPredicate:predicate];
    
    fetchRequest.includesSubentities = NO;
    fetchRequest.fetchBatchSize = 20;
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:self.managedObjectContext
                                                                                                  sectionNameKeyPath:nil
                                                                                                           cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    
    return _fetchedResultsController;
    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.productsTV beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.productsTV insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.productsTV deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
      default:
            return;
    }
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.productsTV;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:anObject];
            break;
        case NSFetchedResultsChangeMove:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:anObject];
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {

    [self countUpTotalSum];
        
    [self.productsTV endUpdates];
    
}

@end
