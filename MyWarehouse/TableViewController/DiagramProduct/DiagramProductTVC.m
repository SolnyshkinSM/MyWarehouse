//
//  DiagramProductTVC.m
//  MyWarehouse
//
//  Created by Administrator on 23.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import "DiagramProductTVC.h"

#import "DiagramProductTVCell.h"

#import "MyWarehouse+CoreDataModel.h"

@interface DiagramProductTVC ()

@end

@implementation DiagramProductTVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configureView];
      
}

#pragma mark - Configure

- (void)configureView {
    self.navigationItem.title = @"Остатки";    
}

#pragma mark - Actions

- (void)configureCell:(DiagramProductTVCell *)cell withObject:(id)object {
  
    Product *product = (Product *)object;
    cell.nameLabel.text = product.name;
    cell.priceLabel.text = [receiveCurrentNumberFormatter() stringFromNumber:@(product.price)];
    cell.imageView.image = [UIImage imageWithData:product.logo];
    cell.alpha = 0;
    
    NSDictionary *balanseDictionary = [self receiveBalanseForProduct:product];
    cell.balanceLabel.text = [receiveCurrentNumberFormatter() stringFromNumber:balanseDictionary[@"TotalQuantity"]];
    
    [UIView animateWithDuration:2 animations:^{
        cell.alpha = 1;
    }];
    
}

- (NSDictionary *)receiveBalanseForProduct:(Product *)product {
    
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
    
    
    NSExpressionDescription *expression = [[NSExpressionDescription alloc] init];
    [expression setName:@"TotalQuantity"];
    [expression setExpression:[NSExpression expressionWithFormat:@"@sum.quantity"]];
    [expression setExpressionResultType:NSDecimalAttributeType];
    
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:@"product.name", expression, nil]];
    [fetchRequest setPropertiesToGroupBy:[NSArray arrayWithObjects:@"product.name", nil]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"product = %@", product]];
    [fetchRequest setResultType:NSDictionaryResultType];
    
    NSError *error = nil;
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Unresolved error %@, %@", error, error.localizedDescription);
    }
    
    if ([resultArray count] > 0) {
        return resultArray[0];
    } else {
        return @{@"TotalQuantity": @0};
    }
    
    
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifierCell = @"DiagramProductTVCell";
    
    DiagramProductTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
        
    id object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self configureCell:cell withObject:object];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark - NSFetchedResultsControllerDelegate

@synthesize fetchedResultsController = _fetchedResultsController;

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = Product.fetchRequest;
        
    NSSortDescriptor *sortDescriptorName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptorName]];
           
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
