//
//  CompanyClientTVC.h
//  MyWarehouse
//
//  Created by Administrator on 13.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import "TemplateCoreDataTVC.h"

#import "Utils.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompanyClientTVC : TemplateCoreDataTVC

@property (strong, nonatomic) UIResponder *delegateVC;
@property (assign, nonatomic) TypeObjectModel typeObjectModel;

@end

NS_ASSUME_NONNULL_END
