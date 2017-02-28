//
//  MKMapView+MapViewUtil.h
//  Onetalking
//
//  Created by Elwin on 16/2/23.
//  Copyright © 2016年 OneTalk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MKMapView (MapViewUtil)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end
