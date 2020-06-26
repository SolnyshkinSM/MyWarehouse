//
//  MapAnnotation.h
//  MyWarehouse
//
//  Created by Administrator on 13.06.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, nullable) NSString *title;

@end

NS_ASSUME_NONNULL_END
