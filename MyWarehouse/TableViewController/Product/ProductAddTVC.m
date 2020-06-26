//
//  ProductAddTVC.m
//  MyWarehouse
//
//  Created by Administrator on 16.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import "ProductAddTVC.h"

#import "StorageUnitsTVC.h"

#import "MyWarehouse+CoreDataModel.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface ProductAddTVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) Units *selectedUnits;

@end

@implementation ProductAddTVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
           
    if (self.currentObject) {
        
        Product *product = (Product *)self.currentObject;
        
        self.nameTextField.text = product.name;
        self.logoImageView.image = [UIImage imageWithData:product.logo];
        self.priceTextField.text = [receiveCurrentNumberFormatter() stringFromNumber:@(product.price)];
        
        self.selectedUnits = product.units;
        self.unitsTextField.text = product.units.name;
        
        self.productServiceSegmentedControl.selectedSegmentIndex = product.isProduct ? 0 : 1;
        
    }
        
}

#pragma mark - Action

- (IBAction)okAction:(UIButton *)sender {
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
    id newObject = nil;
    if (self.currentObject) {
        newObject = self.currentObject;
    } else {
        newObject = [[Product alloc] initWithContext:context];
    }
      
    [newObject setValue:self.nameTextField.text forKey:@"name"];
    [newObject setValue:self.selectedUnits forKey:@"units"];
    
    NSNumberFormatter *formatter = receiveCurrentNumberFormatter();
    NSNumber *numberPrice = [formatter numberFromString:self.priceTextField.text];
    [newObject setValue:numberPrice forKey:@"price"];
    
    BOOL product = self.productServiceSegmentedControl.selectedSegmentIndex == 0;
    if (product) {
        [newObject setValue:@(YES) forKey:@"product"];
        [newObject setValue:@(NO) forKey:@"service"];
    } else {
        [newObject setValue:@(NO) forKey:@"product"];
        [newObject setValue:@(YES) forKey:@"service"];
    }
    
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

- (void)selectedValueDelegateTVC:(id)object {
    
    if ([object isKindOfClass:[Units class]]) {
        self.selectedUnits = object;
        self.unitsTextField.text = [(Units *)object name];
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

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.priceTextField]) {
        textField.text = [receiveCurrentNumberFormatter() stringFromNumber:@([textField.text doubleValue])];
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.unitsTextField]) {
        
        [self.view endEditing:YES];
        
        StorageUnitsTVC *storageUnitsTVC = [[StorageUnitsTVC alloc] init];
        storageUnitsTVC.typeObjectModel =TypeObjectModelUnits;
        storageUnitsTVC.delegateVC = self;
        [self.navigationController presentViewController:storageUnitsTVC animated:YES completion:nil];
        
    }
        
    return YES;
    
}

@end
