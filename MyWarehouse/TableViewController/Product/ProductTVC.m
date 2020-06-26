//
//  ProductTVC.m
//  MyWarehouse
//
//  Created by Administrator on 16.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import "ProductTVC.h"

#import "ProductAddTVC.h"
#import "ProductTVCell.h"
#import "ComingConsumptionVC.h"

#import "MyWarehouse+CoreDataModel.h"

@interface ProductTVC () <UISearchBarDelegate>

@end

@implementation ProductTVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configureView];
      
}

#pragma mark - Configure

- (void)configureView {
    
    self.navigationItem.title = @"Номенклатура";    
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addNewObject:)];
    self.navigationItem.rightBarButtonItem = addItem;
        
}

#pragma mark - Actions

-(void)addNewObject:(UIBarButtonItem *)sender {
    
    ProductAddTVC *productAddTVC = (ProductAddTVC *)receiveTableViewController(@"ProductAddTVC");
    productAddTVC.managedObjectContext = self.fetchedResultsController.managedObjectContext;
   
    [self.navigationController showViewController:productAddTVC sender:nil];
    
}

-(void)configureCell:(ProductTVCell *)cell withObject:(id)object {
    
    cell.nameLabel.text = [object name];
    cell.logoImageView.image = [UIImage imageWithData:[object logo]];
    cell.priceLabel.text = [receiveCurrentNumberFormatter() stringFromNumber:@([object price])];
    
}

#pragma mark - Table view data source

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.fetchedResultsController sectionIndexTitles];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifierCell = @"ProductCell";
    
    ProductTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    
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
    
    if (self.delegateVC && [self.delegateVC isKindOfClass:[ComingConsumptionVC class]]) {
        ComingConsumptionVC *comingVC = (ComingConsumptionVC *)self.delegateVC;
        [comingVC selectedValueDelegateTVC:currentObject];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    ProductAddTVC *productAddTVC = (ProductAddTVC *)receiveTableViewController(@"ProductAddTVC");
    productAddTVC.managedObjectContext = self.fetchedResultsController.managedObjectContext;
    
    if (currentObject) {
        productAddTVC.currentObject = currentObject;
    }
    
    [self.navigationController showViewController:productAddTVC sender:nil];
    
}

#pragma mark - NSFetchedResultsControllerDelegate

@synthesize fetchedResultsController = _fetchedResultsController;

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = Product.fetchRequest;
        
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    fetchRequest.includesSubentities = NO;
    fetchRequest.fetchBatchSize = 20;
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:self.managedObjectContext
                                                                                                  sectionNameKeyPath:@"name"
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

#pragma mark - UISearchBarDelegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [searchBar setShowsCancelButton:YES animated:YES];
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSPredicate *predicate = nil;
    if ([searchText length] != 0) {
        predicate = [NSPredicate predicateWithFormat:@"name contains [cd] %@", searchText];
    }
    
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
    
}

@end
