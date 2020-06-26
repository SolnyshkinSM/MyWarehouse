//
//  ComingConsumptionTVCell.h
//  MyWarehouse
//
//  Created by Administrator on 17.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ComingConsumptionTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoClientImageView;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *clientLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalSumLabel;

@end

NS_ASSUME_NONNULL_END
