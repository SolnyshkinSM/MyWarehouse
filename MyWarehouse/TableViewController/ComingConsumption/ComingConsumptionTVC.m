//
//  ComingConsumptionTVC.m
//  MyWarehouse
//
//  Created by Administrator on 17.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import "ComingConsumptionTVC.h"

#import "ComingConsumptionTVCell.h"
#import "ComingConsumptionVC.h"

#import "MyWarehouse+CoreDataModel.h"

@interface ComingConsumptionTVC ()

@end

@implementation ComingConsumptionTVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configureView];
      
}

#pragma mark - Configure

- (void)configureView {
        
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addNewObject:)];
    self.navigationItem.rightBarButtonItem = addItem;
    
    self.navigationItem.title = self.typeObjectModel == TypeObjectModelComing ? @"Приход" : @"Расход";
    
}

#pragma mark - Actions

-(void)addNewObject:(UIBarButtonItem *)sender {
    
    ComingConsumptionVC *comingVC = (ComingConsumptionVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ComingVC"];
    comingVC.managedObjectContext = self.fetchedResultsController.managedObjectContext;
    comingVC.typeObjectModel = self.typeObjectModel;

    [self.navigationController showViewController:comingVC sender:nil];
    
}

-(void)configureCell:(ComingConsumptionTVCell *)cell withObject:(id)object {
  
    cell.numberLabel.text = [object number];
    cell.dateLabel.text = [receiveCurrentDateFormatter() stringFromDate:[object date]];
    cell.totalSumLabel.text = [receiveCurrentNumberFormatter() stringFromNumber:@([object totalSum])];
    
    Client *client = (Client *)[object client];
    cell.clientLabel.text = client.name;
    cell.imageView.image = [UIImage imageWithData:client.logo];
    
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifierCell = @"ComingTVCell";
    
    ComingConsumptionTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
        
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

    ComingConsumptionVC *comingVC = (ComingConsumptionVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ComingVC"];
    comingVC.managedObjectContext = self.fetchedResultsController.managedObjectContext;
    comingVC.typeObjectModel = self.typeObjectModel;

    if (currentObject) {
        comingVC.currentObject = currentObject;
    }

    [self.navigationController showViewController:comingVC sender:nil];
        
}

#pragma mark - NSFetchedResultsControllerDelegate

@synthesize fetchedResultsController = _fetchedResultsController;

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
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
    
        
    NSSortDescriptor *sortDescriptorDate = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSSortDescriptor *sortDescriptorNumber = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptorDate, sortDescriptorNumber]];
           
    fetchRequest.includesSubentities = NO;
    fetchRequest.fetchBatchSize = 20;
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:self.managedObjectContext
                                                                                                  sectionNameKeyPath:@"company.name"
                                                                                                           cacheName:@"Company"];
    
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
