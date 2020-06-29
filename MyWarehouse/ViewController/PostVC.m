//
//  PostVC.m
//  MyWarehouse
//
//  Created by Administrator on 23.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import "PostVC.h"

#import <MobileCoreServices/MobileCoreServices.h>

#import "ServerManager.h"

#import "User.h"

@interface PostVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (assign, nonatomic) BOOL firstTimeAppear;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) UIImage *currentImage;

@end

@implementation PostVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configureView];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (self.firstTimeAppear) {
        self.firstTimeAppear = NO;
        
        [[ServerManager sharedManager] authorizeUser:^(User * _Nonnull user) {
            //NSLog(@"Authorized user: %@ %@", user.firstName, user.lastName);
            self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
        }];
    }
    
}

#pragma mark - Configure

- (void)configureView {
    
    self.firstTimeAppear = YES;
    self.nameAttachLabel.text = @"";
    
}

#pragma mark - Actions

- (IBAction)addPostAction:(UIButton *)sender {
    
    [[ServerManager sharedManager] postText:self.textTextView.text
                                      image:self.currentImage
                                onGroupWall:@"15853729"
                                  onSuccess:^(id result) {

        if (result) {
            [self.navigationController popViewControllerAnimated:YES];
        }

    } onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {

    }];
        
}

- (IBAction)addAttachAction:(UIButton *)sender {
    
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    self.picker.mediaTypes = @[(NSString *)kUTTypeImage];
    self.picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:self.picker animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
   
    UIImage *newImage = info[UIImagePickerControllerOriginalImage];
    self.currentImage = newImage;
    self.nameAttachLabel.text = @"1";
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    self.currentImage = nil;
    self.nameAttachLabel.text = @"0";
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
