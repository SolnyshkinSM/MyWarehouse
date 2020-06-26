//
//  CatalogTVC.m
//  MyWarehouse
//
//  Created by Administrator on 13.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import "CatalogTVC.h"

#import "CompanyClientTVC.h"
#import "StorageUnitsTVC.h"
#import "ProductTVC.h"

#import "Utils.h"

@interface CatalogTVC ()

@end

@implementation CatalogTVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *message = nil;
    if ([cell.reuseIdentifier isEqualToString:@"Company"]) {
        message = @"Справочник предназначен для ведения списка организаций, входящих в состав предприятия, и хранения постоянных сведений о них.";
    } else if ([cell.reuseIdentifier isEqualToString:@"Client"]) {
        message = @"Справочник предназначен для хранения информации о тех юридических (физических) лицах "
                    "партнеров предприятия (поставщиков, клиентов) с которыми зарегистрированы регламентированные (финансовые) отношения.";
    } else if ([cell.reuseIdentifier isEqualToString:@"Storage"]) {
        message = @"Справочник предназначен для регистрации перечня тех складских территорий, в которых хранится товар.";
    } else if ([cell.reuseIdentifier isEqualToString:@"Product"]) {
        message = @"Справочник предназначен для хранения информации о номенклатурных позициях следующих типов: "
                    "товар, услуга, работа, тара и набор.";
    } else if ([cell.reuseIdentifier isEqualToString:@"Units"]) {
        message = @"Справочник предназначен для регистрации перечня единиц измерений, определенных для позиций номенклатуры, "
                    "и упаковок товаров, которые могут использоваться в качестве альтернативных единиц измерения номенклатуры.";
    }
    
    if (message) {
        [self presentViewController:receiveAlert(@"info", message) animated:YES completion:nil];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
       
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.reuseIdentifier isEqualToString:@"Company"] || [cell.reuseIdentifier isEqualToString:@"Client"]) {
        CompanyClientTVC *companyTableViewController = [[CompanyClientTVC alloc] init];
        companyTableViewController.typeObjectModel = [cell.reuseIdentifier isEqualToString:@"Company"] ? TypeObjectModelCompany : TypeObjectModelClient;
        [self.navigationController showViewController:companyTableViewController sender:nil];
    } else if ([cell.reuseIdentifier isEqualToString:@"Storage"] || [cell.reuseIdentifier isEqualToString:@"Units"]) {
        StorageUnitsTVC *storageUnitsTVC = [[StorageUnitsTVC alloc] init];
        storageUnitsTVC.typeObjectModel = [cell.reuseIdentifier isEqualToString:@"Storage"] ? TypeObjectModelStorage : TypeObjectModelUnits;
        [self.navigationController showViewController:storageUnitsTVC sender:nil];
    } else if ([cell.reuseIdentifier isEqualToString:@"Product"]) {
        ProductTVC *productTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductTVC"];
        [self.navigationController showViewController:productTVC sender:nil];
    }
    
}


@end
