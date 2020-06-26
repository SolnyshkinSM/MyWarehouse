//
//  ViewController.m
//  MyWarehouse
//
//  Created by Administrator on 13.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import "ViewController.h"

#import "Utils.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configureView];
    
}

#pragma mark - Configure

- (void)configureView {
    
    CGRect viewRect = self.view.bounds;
    
    CGFloat maxX = CGRectGetMaxX(viewRect);
    CGFloat maxY = CGRectGetMaxY(viewRect);
    
    CGFloat midX = CGRectGetMidX(viewRect);
    CGFloat midY = CGRectGetMidY(viewRect);
    
    self.loaderImageView.center = CGPointMake(maxX + CGRectGetWidth(self.loaderImageView.bounds), midY);
    self.nameImageView.center = CGPointMake(CGRectGetMinX(viewRect) - CGRectGetWidth(self.nameImageView.bounds), midY / 2);
    self.emailLabel.center = CGPointMake(midX, maxY);
    
    [UIView animateWithDuration:2 animations:^{
        self.loaderImageView.center = CGPointMake(midX, midY);
        self.nameImageView.center = CGPointMake(midX, midY / 2);
        self.emailLabel.center = CGPointMake(midX, maxY - CGRectGetHeight(self.emailLabel.bounds) * 2);
    }];
    
    
    [NSTimer scheduledTimerWithTimeInterval:3 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [self.view.window setRootViewController:receiveCurrentTabBarController()];
    }];
    
}

@end
