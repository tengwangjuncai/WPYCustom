//
//  MKMapView+ZoomLevel.h
//  ImGuider
//
//  Created by llt on 2017/4/12.
//  Copyright © 2017年 imguider. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

- (double)getZoomLevel;

@end
