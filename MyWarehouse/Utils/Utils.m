//
//  Utils.m
//  MyWarehouse
//
//  Created by Administrator on 12.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import "Utils.h"

#import <UIKit/UIAlertController.h>
#import <UIKit/UITableViewController.h>
#import <UIKit/UIStoryboard.h>
#import <UIKit/UITabBarController.h>
#import <UIKit/UITabBarItem.h>
#import <UIKit/UINavigationController.h>
#import <UIKit/UIImage.h>

#import "ComingConsumptionTVC.h"

UIAlertController *receiveAlert(NSString *title, NSString *message) {
 
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alert addAction:defaultAction];
    
    return alert;

}

UITableViewController * receiveTableViewController(NSString *identifier) {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    return [mainStoryboard instantiateViewControllerWithIdentifier:identifier];
    
}

NSNumberFormatter * receiveCurrentNumberFormatter(void) {
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return numberFormatter;
    
}

NSDateFormatter * receiveCurrentDateFormatter(void) {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MMMM.yyyy"];
    
    return dateFormatter;
    
}

UITabBarController * receiveCurrentTabBarController(void) {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UITabBarController *tabBarController = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarController"];
        
    UINavigationController *homeNC = [mainStoryboard instantiateViewControllerWithIdentifier:@"HomeNC"];
    homeNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Главная" image:[UIImage imageNamed:@"Home_32.png"] tag:0];
    
    UINavigationController *catalogNC = [mainStoryboard instantiateViewControllerWithIdentifier:@"CatalogNC"];
    catalogNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Справочники" image:[UIImage imageNamed:@"Catalog_32.png"] tag:0];
    
    UINavigationController *comingNC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ComingConsumptionNC"];
    ((ComingConsumptionTVC *)comingNC.topViewController).typeObjectModel = TypeObjectModelComing;
    comingNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Приход" image:[UIImage imageNamed:@"Coming_32.png"] tag:1];
    
    UINavigationController *consumptionNC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ComingConsumptionNC"];
    ((ComingConsumptionTVC *)consumptionNC.topViewController).typeObjectModel = TypeObjectModelConsumption;
    consumptionNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Расход" image:[UIImage imageNamed:@"Consumption_32.png"] tag:2];
    
    tabBarController.viewControllers = @[homeNC, catalogNC, comingNC, consumptionNC];
    
    return tabBarController;
    
}

UIColor * receiveRandomColor(void) {
    
    CGFloat red = (float)(arc4random() % 256) / 255;
    CGFloat green = (float)(arc4random() % 256) / 255;
    CGFloat blue = (float)(arc4random() % 256) / 255;
                          
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.f];
    
}
