//
//  HomeTVC.m
//  MyWarehouse
//
//  Created by Administrator on 20.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import "HomeTVC.h"

#import "DiagramVC.h"
#import "DiagramProductTVC.h"
#import "ComingConsumptionVC.h"

#import "Utils.h"

#import "AppDelegate.h"
#import <WebKit/WebKit.h>

#import "MyWarehouse+CoreDataModel.h"

@interface HomeTVC () <UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *collectionArray;

@end

@implementation HomeTVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
        
    [self configureView];
    
    [self configureCell];
    
    //NSNotificationCenter
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(AddNewObjectDidChangeNotification:)
                                                 name:ComingConsumptionVCAddNewObjectDidChangeNotification
                                               object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Configure

- (void)configureView {
    
    self.managedObjectContext = ((AppDelegate *)UIApplication.sharedApplication.delegate).persistentContainer.viewContext;
    
    
    self.comingSumLabel.text = [receiveCurrentNumberFormatter()
                                stringFromNumber:[self receiveTotalSumForFetch:Coming.fetchRequest]];
    self.consumptionSumLabel.text = [receiveCurrentNumberFormatter()
                                     stringFromNumber:[self receiveTotalSumForFetch:Consumption.fetchRequest]];
     
    self.comingProductLabel.text = [receiveCurrentNumberFormatter()
                                stringFromNumber:[self receiveTotalQuantityForFetch:ComingTable.fetchRequest]];
    self.consumptionProductLabel.text = [receiveCurrentNumberFormatter()
                                     stringFromNumber:[self receiveTotalQuantityForFetch:ConsumptionTable.fetchRequest]];
    
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
}

- (void)configureCell {
   
    self.collectionArray = @[
    @{@"name":@"Manual", @"image":@"Manual_128.png"},
    @{@"name":@"Vk", @"image":@"Vk_128.png"},
    @{@"name":@"Twitter", @"image":@"Twitter_128.png"},
    @{@"name":@"Play", @"image":@"Play_128.png"},
    @{@"name":@"Linkedin", @"image":@"Linkedin_128.png"},
    @{@"name":@"Instagram", @"image":@"Instagram_128.png"},
    @{@"name":@"Facebook", @"image":@"Facebook_128.png"}
    ];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    layout.minimumLineSpacing = 4.f;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 2, 0, 2);
    [layout setSectionInset:insets];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.collectionTVCell.bounds collectionViewLayout:layout];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CellCollection"];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionTVCell addSubview:self.collectionView];
    
}

#pragma mark - Action

- (void)refreshTable {
    
   [self configureView];
    
   [self.refreshControl endRefreshing];
    
}

- (NSNumber *)receiveTotalSumForFetch:(NSFetchRequest *)fetchRequest {
   
    NSExpressionDescription *expression = [[NSExpressionDescription alloc] init];
    [expression setName:@"TotalSum"];
    [expression setExpression:[NSExpression expressionWithFormat:@"@sum.totalSum"]];
    [expression setExpressionResultType:NSDecimalAttributeType];

    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:@"company", expression, nil]];
    [fetchRequest setResultType:NSDictionaryResultType];

    NSError *error = nil;
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Unresolved error %@, %@", error, error.localizedDescription);
    }

    if ([resultArray count] != 0) {
        return resultArray[0][@"TotalSum"];
    } else {
        return [NSNumber numberWithInt:0];
    }
   
}

- (NSNumber *)receiveTotalQuantityForFetch:(NSFetchRequest *)fetchRequest {
   
    NSExpressionDescription *expression = [[NSExpressionDescription alloc] init];
    [expression setName:@"TotalSum"];
    [expression setExpression:[NSExpression expressionWithFormat:@"@sum.quantity"]];
    [expression setExpressionResultType:NSDecimalAttributeType];

    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:expression, nil]];
    [fetchRequest setResultType:NSDictionaryResultType];

    NSError *error = nil;
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Unresolved error %@, %@", error, error.localizedDescription);
    }

    if ([resultArray count] != 0) {
        return resultArray[0][@"TotalSum"];
    } else {
        return [NSNumber numberWithInt:0];
    }
    
}

- (void)AddNewObjectDidChangeNotification:(NSNotification *)notification {
    
    NSNumber *value = [notification.userInfo objectForKey:ComingConsumptionVCAddNewObjectUserInfoKey];
    
    if ([value boolValue]) {
        [self refreshTable];
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.reuseIdentifier isEqualToString:@"ComingCell"] || [cell.reuseIdentifier isEqualToString:@"ConsumptionCell"]) {
        DiagramVC *diagramVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DiagramVC"];
        diagramVC.managedObjectContext = self.managedObjectContext;
        diagramVC.typeObjectModel = [cell.reuseIdentifier isEqualToString:@"ComingCell"] ? TypeObjectModelComing : TypeObjectModelConsumption;
        [self.navigationController showViewController:diagramVC sender:nil];
    } else if ([cell.reuseIdentifier isEqualToString:@"comingProduct"] || [cell.reuseIdentifier isEqualToString:@"consumptionProduct"]) {
        DiagramProductTVC *diagramProductTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DiagramProductTVC"];
        diagramProductTVC.typeObjectModel = [cell.reuseIdentifier isEqualToString:@"comingProduct"] ? TypeObjectModelComing : TypeObjectModelConsumption;
        [self.navigationController showViewController:diagramProductTVC sender:nil];
    }
        
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.collectionArray count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"CellCollection";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSDictionary *dictionary = [self.collectionArray objectAtIndex:indexPath.row];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
    imageView.image = [UIImage imageNamed:dictionary[@"image"]];
     
    [cell removeFromSuperview];
    [cell addSubview:imageView];
    
    cell.layer.cornerRadius = CGRectGetWidth(cell.bounds) / 2;
    cell.backgroundColor = [UIColor lightGrayColor];
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 80);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dictionary = [self.collectionArray objectAtIndex:indexPath.row];
    
    if ([dictionary[@"name"] isEqualToString:@"Vk"]) {
        UINavigationController *postVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PostVC"];
        [self.navigationController showViewController:postVC sender:nil];
    } else if ([dictionary[@"name"] isEqualToString:@"Manual"]) {
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = [UIColor whiteColor];
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:view.bounds];
        [view addSubview:webView];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"manual.pdf" ofType:nil];
        
        NSURL *fileUrl = [[NSURL alloc] initFileURLWithPath:filePath];
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:fileUrl];
        
        [webView loadRequest:request];
                
        UIViewController *viewController = [[UIViewController alloc] init];
        viewController.navigationItem.title = @"Инструкция";
        viewController.view = view;
                
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController showViewController:viewController sender:nil];
        });
        
    }
    
}

@end
