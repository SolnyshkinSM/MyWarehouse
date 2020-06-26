//
//  StorageUnitsTVC.m
//  MyWarehouse
//
//  Created by Administrator on 15.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import "StorageUnitsTVC.h"
#import "StorageUnitsAddTVC.h"
#import "ProductAddTVC.h"
#import "ComingConsumptionVC.h"

#import "MyWarehouse+CoreDataModel.h"

@interface StorageUnitsTVC ()

@end

@implementation StorageUnitsTVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configureView];
      
}

#pragma mark - Configure

- (void)configureView {
    
    self.navigationItem.title = self.typeObjectModel == TypeObjectModelStorage ? @"Склады" : @"Единицы измерения";
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addNewObject:)];
    self.navigationItem.rightBarButtonItem = addItem;
    
}

#pragma mark - Actions

-(void)addNewObject:(UIBarButtonItem *)sender {
    
    StorageUnitsAddTVC *storageUnitsAddTVC = (StorageUnitsAddTVC *)receiveTableViewController(@"StorageUnitsAddTVC");
    storageUnitsAddTVC.managedObjectContext = self.fetchedResultsController.managedObjectContext;
    storageUnitsAddTVC.typeObjectModel = self.typeObjectModel;

    [self.navigationController showViewController:storageUnitsAddTVC sender:nil];
    
}

-(void)configureCell:(UITableViewCell *)cell withObject:(id)object {
    
    cell.textLabel.text = [object name];
    cell.imageView.image = [UIImage imageWithData:[object logo]];
    
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifierCell = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
    }
    
    id object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self configureCell:cell withObject:object];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
       
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id currentObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (self.delegateVC && [self.delegateVC isKindOfClass:[ProductAddTVC class]]) {
        ProductAddTVC *productAddTVC = (ProductAddTVC *)self.delegateVC;
        [productAddTVC selectedValueDelegateTVC:currentObject];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    } else if (self.delegateVC && [self.delegateVC isKindOfClass:[ComingConsumptionVC class]]) {
        ComingConsumptionVC *comingVC = (ComingConsumptionVC *)self.delegateVC;
        [comingVC selectedValueDelegateTVC:currentObject];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    StorageUnitsAddTVC *storageUnitsAddTVC = (StorageUnitsAddTVC *)receiveTableViewController(@"StorageUnitsAddTVC");
    storageUnitsAddTVC.managedObjectContext = self.fetchedResultsController.managedObjectContext;
    storageUnitsAddTVC.typeObjectModel = self.typeObjectModel;
    
    if (currentObject) {
        storageUnitsAddTVC.currentObject = currentObject;
    }
    
    [self.navigationController showViewController:storageUnitsAddTVC sender:nil];
        
}

#pragma mark - NSFetchedResultsControllerDelegate

@synthesize fetchedResultsController = _fetchedResultsController;

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = nil;
    switch (self.typeObjectModel) {
        case TypeObjectModelStorage:
            fetchRequest = Storage.fetchRequest;
            break;
        case TypeObjectModelUnits:
            fetchRequest = Units.fetchRequest;
            break;
        default:
            break;
    }
        
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
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

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
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

@end
