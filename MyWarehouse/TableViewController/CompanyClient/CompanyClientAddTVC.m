//
//  CompanyClientAddTVC.m
//  MyWarehouse
//
//  Created by Administrator on 13.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import "CompanyClientAddTVC.h"

#import <MobileCoreServices/MobileCoreServices.h>

#import "MapAnnotation.h"

#import <MapKit/MapKit.h>
#import "MyWarehouse+CoreDataModel.h"

@interface CompanyClientAddTVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) UIImagePickerController *picker;

@end

@implementation CompanyClientAddTVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configureView];
        
}

#pragma mark - Configure

- (void)configureView {
    
    switch (self.typeObjectModel) {
        case TypeObjectModelCompany:
            self.logoImageView.image = [UIImage imageNamed:@"Company_128.png"];
            break;
        case TypeObjectModelClient:
            self.logoImageView.image = [UIImage imageNamed:@"Client_128.png"];
            break;
        default:
            break;
    }
    
    if (self.currentObject) {
        self.nameTextField.text = [self.currentObject name];
        self.logoImageView.image = [UIImage imageWithData:[self.currentObject logo]];
        if ([self.currentObject latitude] != 0 && [self.currentObject longitude] != 0) {
            [self addAnnotationForCoordinate:CLLocationCoordinate2DMake([self.currentObject latitude], [self.currentObject longitude])];
        }
    }
    
}

#pragma mark - Action

- (IBAction)markAction:(UIButton *)sender {
    [self addAnnotationForCoordinate:self.mapView.region.center];    
}

- (void)addAnnotationForCoordinate:(CLLocationCoordinate2D)coordinate {
    
    MapAnnotation *annotation = [[MapAnnotation alloc] init];
    annotation.title = [self.nameTextField.text isEqualToString:@""] ? @"Метка" : self.nameTextField.text;
    annotation.coordinate = coordinate;
    
    [self.mapView addAnnotation:annotation];
    [self actionShowAllAnnotation];
    
}

-(void)actionShowAllAnnotation {
    
    MKMapRect zoomRect = MKMapRectNull;
    
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        
        CLLocationCoordinate2D location = annotation.coordinate;
        
        MKMapPoint center = MKMapPointForCoordinate(location);
        
        static double delta = 20000;
        
        MKMapRect rect = MKMapRectMake(center.x - delta, center.y - delta, delta * 2, delta * 2);
        
        zoomRect = MKMapRectUnion(zoomRect, rect);
        
    }
    
    zoomRect = [self.mapView mapRectThatFits:zoomRect];
    
    [self.mapView setVisibleMapRect:zoomRect
                        edgePadding:UIEdgeInsetsMake(50, 50, 50, 50)
                           animated:YES];
    
}

- (IBAction)okAction:(UIButton *)sender {
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
    id newObject = nil;
    if (self.currentObject) {
        newObject = self.currentObject;
    } else {
        switch (self.typeObjectModel) {
            case TypeObjectModelCompany:
                newObject = [[Company alloc] initWithContext:context];
                break;
            case TypeObjectModelClient:
                newObject = [[Client alloc] initWithContext:context];
                break;
            default:
                break;
        }
    }
      
    [newObject setValue:self.nameTextField.text forKey:@"name"];
    
    NSData *imageData = UIImagePNGRepresentation(self.logoImageView.image);
    [newObject setValue:imageData forKey:@"logo"];

    MapAnnotation *annotation = [self.mapView.annotations lastObject];
    [newObject setValue:@(annotation.coordinate.latitude) forKey:@"latitude"];
    [newObject setValue:@(annotation.coordinate.longitude) forKey:@"longitude"];
    
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

-(void)actionDescription:(UIButton *)sender {
   
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[self.currentObject latitude] longitude:[self.currentObject longitude]];

    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];

    if ([geoCoder isGeocoding]) {
        [geoCoder cancelGeocode];
    }

    [geoCoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {

        NSString *message = nil;

        if (error) {
            message = [error localizedDescription];
        } else {
            if ([placemarks count] > 0) {

                CLPlacemark *plaseMark = [placemarks firstObject];

                message = [plaseMark description];

            } else {
                message = @"No Plasemarks Found";
            }
        }

        [self presentViewController:receiveAlert(@"Location", message) animated:YES completion:nil];
        
    }];
    
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

#pragma mark - MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *identifier = @"Annotation";
    
    MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!pin) {
        
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        pin.pinTintColor = [UIColor redColor];
        pin.animatesDrop = YES;
        pin.canShowCallout = YES;
        pin.draggable = YES;
        
        UIButton *descriptionButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [descriptionButton addTarget:self action:@selector(actionDescription:) forControlEvents:UIControlEventTouchUpInside];
        pin.rightCalloutAccessoryView = descriptionButton;
        
    } else {
        pin.annotation = annotation;
    }
    
    return pin;
    
}

@end
