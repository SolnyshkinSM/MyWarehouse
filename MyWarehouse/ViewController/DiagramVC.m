//
//  DiagramVC.m
//  MyWarehouse
//
//  Created by Administrator on 21.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import "DiagramVC.h"

#import "MyWarehouse+CoreDataModel.h"

@interface DiagramVC ()

@end

@implementation DiagramVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configureView];
    
}

#pragma mark - Configure

- (void)configureView {
   
    NSFetchRequest *fetchRequest = nil;
    switch (self.typeObjectModel) {
        case TypeObjectModelComing:
            fetchRequest = Coming.fetchRequest;
            self.navigationItem.title = @"Приход";
            break;
        case TypeObjectModelConsumption:
            fetchRequest = Consumption.fetchRequest;
            self.navigationItem.title = @"Расход";
            break;
        default:
            break;
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"client.name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSExpressionDescription *expression = [[NSExpressionDescription alloc] init];
    [expression setName:@"TotalSum"];
    [expression setExpression:[NSExpression expressionWithFormat:@"@sum.totalSum"]];
    [expression setExpressionResultType:NSDecimalAttributeType];
    
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:@"client.name", expression, nil]];
    [fetchRequest setPropertiesToGroupBy:[NSArray arrayWithObjects:@"client.name", nil]];
    [fetchRequest setResultType:NSDictionaryResultType];
    
    NSError *error = nil;
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Unresolved error %@, %@", error, error.localizedDescription);
    }
   
    
    
    float maxHeight = 0;
    for (id object in resultArray) {
        maxHeight = MAX(maxHeight, [object[@"TotalSum"] floatValue]);
    }
    
    
    CGFloat midX = CGRectGetMidX(self.view.bounds);
    CGFloat midY = CGRectGetMidY(self.view.bounds);
    
    NSInteger offset = 60;
    NSInteger countResult = [resultArray count];
    
    for (int item = 0; item < [resultArray count]; item++) {
        
        float totalSum = [resultArray[item][@"TotalSum"] floatValue];

        CGFloat coordinateX = midX - maxHeight * 0.004 / 2;
        CGFloat coordinateY = midY - (offset * countResult) / 2;

        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(coordinateX, coordinateY + offset * item, totalSum * 0.004, 50)];
        view.backgroundColor = receiveRandomColor();
        view.layer.cornerRadius = 25;
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(view.bounds, 5, 5)];
        label.textColor = [UIColor whiteColor];
        label.text = resultArray[item][@"client.name"];
        label.text = [label.text stringByAppendingFormat:@" - %@", [receiveCurrentNumberFormatter() stringFromNumber:@(totalSum)]];
        
        CGPoint centerView = view.center;
        view.center = CGPointMake(arc4random() % (int)CGRectGetMaxX(self.view.bounds), arc4random() % (int)CGRectGetMaxY(self.view.bounds));
        
        [UIView animateWithDuration:3 animations:^{
            view.center = centerView;
        }];
        
        [view addSubview:label];
        [self.view addSubview:view];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [view addGestureRecognizer:recognizer];
                       
    }
      
}

#pragma mark - Actions

- (void)handleGesture:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    UIView *view = tapGestureRecognizer.view;
    UILabel *label = view.subviews[0];
    CGAffineTransform startTransform = view.transform;
      

    [UIView animateWithDuration:1 animations:^{
        view.transform = CGAffineTransformScale(startTransform, 1.13, 1.13);
    }];
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"info" message:label.text
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
        [UIView animateWithDuration:1 animations:^{
            view.transform = startTransform;
        }];
    }];
    
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
