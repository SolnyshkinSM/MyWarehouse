//
//  StorageUnitsAddTVC.m
//  MyWarehouse
//
//  Created by Administrator on 15.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import "StorageUnitsAddTVC.h"

#import "MyWarehouse+CoreDataModel.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface StorageUnitsAddTVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIImagePickerController *picker;

@end

@implementation StorageUnitsAddTVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configureView];
    
}

#pragma mark - Configure

- (void)configureView {
    
    switch (self.typeObjectModel) {
        case TypeObjectModelStorage:
            self.logoImageView.image = [UIImage imageNamed:@"Storage128.png"];
            break;
        case TypeObjectModelUnits:
            self.logoImageView.image = [UIImage imageNamed:@"Units_128.png"];
            break;
        default:
            break;
    }
    
    if (self.currentObject) {
        self.nameTextField.text = [self.currentObject name];
        self.logoImageView.image = [UIImage imageWithData:[self.currentObject logo]];
    }
    
}

#pragma mark - Action

- (IBAction)okAction:(UIButton *)sender {
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
    id newObject = nil;
    if (self.currentObject) {
        newObject = self.currentObject;
    } else {
        switch (self.typeObjectModel) {
            case TypeObjectModelStorage:
                newObject = [[Storage alloc] initWithContext:context];
                break;
            case TypeObjectModelUnits:
                newObject = [[Units alloc] initWithContext:context];
                break;
            default:
                break;
        }
    }
      
    [newObject setValue:self.nameTextField.text forKey:@"name"];
    
    NSData *imageData = UIImagePNGRepresentation(self.logoImageView.image);
    [newObject setValue:imageData forKey:@"logo"];

    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
        
    [self.navigationController popViewControllerAnimated:YES];
        
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.reuseIdentifier isEqualToString:@"logoCell"]) {
        
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.delegate = self;
        self.picker.mediaTypes = @[(NSString *)kUTTypeImage];
        self.picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        [self presentViewController:self.picker animated:YES completion:nil];
        
    }
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
   
    UIImage *newImage = info[UIImagePickerControllerOriginalImage];
    self.logoImageView.image = newImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
