//
//  HomeTVC.h
//  MyWarehouse
//
//  Created by Administrator on 20.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeTVC : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UILabel *comingSumLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumptionSumLabel;

@property (weak, nonatomic) IBOutlet UILabel *comingProductLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumptionProductLabel;

@property (weak, nonatomic) IBOutlet UITableViewCell *collectionTVCell;


@end

NS_ASSUME_NONNULL_END
