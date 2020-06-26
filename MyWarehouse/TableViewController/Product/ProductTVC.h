//
//  ProductTVC.h
//  MyWarehouse
//
//  Created by Administrator on 16.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import "TemplateCoreDataTVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductTVC : TemplateCoreDataTVC

@property (strong, nonatomic) UIResponder *delegateVC;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

NS_ASSUME_NONNULL_END
