//
//  MapVC.m
//  WPYCustomControls
//
//  Created by 王鹏宇 on 2017/7/31.
//  Copyright © 2017年 wpy_person. All rights reserved.
//

#import "MapVC.h"
#import <GLKit/GLKit.h>
#import <MapKit/MapKit.h>
#import "MKMapView+ZoomLevel.h"
#import "IGAlertView.h"
#import "IGAnnotation.h"
#import "ClusterAnnotationView.h"
#import "ViewAnnView.h"
#import <kingpin/kingpin.h>
#import "IGUtils.h"
static CGFloat minimunZoomARC = 0.0001;
static CGFloat annotatonGrgionPadFactor = 1.15;
static CGFloat maxDefreesARC = 360;
#ifndef kSystemVersion
#define kSystemVersion [[UIDevice currentDevice] systemVersion].floatValue
#endif

#ifndef kiOS9Later
#define kiOS9Later (kSystemVersion >= 9)
#endif
@interface MapVC ()<CLLocationManagerDelegate,MKMapViewDelegate,ViewAnnViewDelegate>

@property (nonatomic, strong) MKMapView * mapView;

@property  (nonatomic, strong)CLLocationManager * locationManager;
@property (nonatomic, strong) CLLocation * location;
@property (nonatomic, strong) MKAnnotationView * userView;
@property (nonatomic, strong) NSArray<id<MKAnnotation>> * annotations;
@property (nonatomic, strong) KPClusteringController * clusteringController;

@end

@implementation MapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setup];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadDataSource];
    });
    
}

- (void)mapWillAppear {
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    //    @weakify(self);
    //    [[LocationManager sharedManager] startUpdatingHeadingBlock:^(CLHeading *newHeading) {
    //        @strongify(self);
    //        //        self.locationDirection = newHeading.magneticHeading;
    //        [self transformHeading:newHeading.magneticHeading];
    //    }];
    // dispatch_resume(self.timer);
}

- (void)mapWillDisappear {
    
    self.mapView.showsUserLocation = NO;
    self.mapView.delegate = nil;
    // [[LocationManager sharedManager] stopUpdatingHeading];
    // dispatch_suspend(_timer);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self mapWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self mapWillDisappear];
}
- (void)setup {
    
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = 100;// 设置定位距离过滤参数（当本次定位和上次定位超过这个值时，调用代理方法）
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;// 设置定位精度（精度越高越耗电）
    //定位服务是否可用
    BOOL enable = [CLLocationManager locationServicesEnabled];
    
    //是否具有定位权限
    int status = [CLLocationManager authorizationStatus];
    
    if (status == 2) {
        
        [IGAlertView alertWithTitle:@"" message:@"定位提示,去设置" cancelButtonTitle:@"取消" commitBtn:@"确定" commit:^{
            
        } cancel:^{
            
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }];
    }else if(!enable || status < 3){
        //请求权限
        [_locationManager requestWhenInUseAuthorization];
    }
    
    [_locationManager startUpdatingLocation];
    self.mapView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
}

- (void)loadDataSource {
    
    NSInteger p = 1;
    NSMutableArray *annArray = [NSMutableArray array];
    for (int i = 0; i < 10; i ++) {
    
        p *= -1;
        IGAnnotation * annotation = [[IGAnnotation alloc] init];
      
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(self.location.coordinate.latitude + p * i *0.01,self.location.coordinate.longitude + p * i *0.01);
        
        annotation.coordinate = location;
        
        annotation.title = [NSString stringWithFormat:@"%d",i];
        annotation.tag = i;
        
        NSLog(@"%f-----%f",annotation.coordinate.latitude,annotation.coordinate.longitude);
        [annArray addObject:annotation];
    }
    
    
    self.annotations = [NSArray arrayWithArray:annArray];
   // [self zoomMapViewToFitAnnotationsAnimated:YES];
}


- (void)setAnnotations:(NSArray<id<MKAnnotation>> *)annotations {
    
    _annotations = annotations;
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.clusteringController setAnnotations:_annotations];
    
   // [self.mapView addAnnotations:annotations];
}

- (KPClusteringController *)clusteringController {
    
    if (!_clusteringController) {
        KPGridClusteringAlgorithm * algorithm = [KPGridClusteringAlgorithm new];
        algorithm.annotationSize = CGSizeMake(42, 50);
        
        algorithm.clusteringStrategy = KPGridClusteringAlgorithmStrategyTwoPhase;
        
        _clusteringController = [[KPClusteringController alloc] initWithMapView:self.mapView clusteringAlgorithm:algorithm];
        
        _clusteringController.animationOptions = UIViewAnimationCurveEaseOut;
    }
    
    return _clusteringController;
}
//- (CLLocationManager *)locationManager {
//    
//    if (!_locationManager) {
//        
//        _locationManager = [[CLLocationManager alloc] init];
//        _locationManager.delegate = self;
//        _locationManager.distanceFilter = 100;// 设置定位距离过滤参数（当本次定位和上次定位超过这个值时，调用代理方法）
//        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;// 设置定位精度（精度越高越耗电）
//        //定位服务是否可用
//        BOOL enable = [CLLocationManager locationServicesEnabled];
//        
//        //是否具有定位权限
//        int status = [CLLocationManager authorizationStatus];
//        
//        if (status == 2) {
//            
//            [IGAlertView alertWithTitle:@"" message:@"定位提示,去设置" cancelButtonTitle:@"取消" commitBtn:@"确定" commit:^{
//                
//            } cancel:^{
//               
//                NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                [[UIApplication sharedApplication] openURL:url];
//            }];
//        }else if(!enable || status < 3){
//            //请求权限
//            [_locationManager requestWhenInUseAuthorization];
//        }
//        
//        [_locationManager startUpdatingLocation];
//    }
//    
//    return _locationManager;
//}
- (MKMapView *)mapView {
    
    if (!_mapView) {
        
        _mapView = [[MKMapView alloc] init];
        
        if (kiOS9Later) {
            
            _mapView.showsScale = YES;
            _mapView.showsTraffic = NO;
        }
        
        _mapView.showsPointsOfInterest = NO;
        _mapView.showsBuildings = NO;
        _mapView.pitchEnabled = NO;
        _mapView.rotateEnabled = NO;
        
        _mapView.delegate = self;
        [self.view addSubview:_mapView];
        
    }
    
    return _mapView;
}

- (void)zoomMapViewToFitAnnotationsAnimated:(BOOL)animated {
    
    NSMutableArray *annsArray = [NSMutableArray array];
    
    for (MKPointAnnotation *ann in self.annotations) {
        
        if ([ann isKindOfClass:[MKUserLocation class]]) {
            
            continue;
        }
        
        CLLocationCoordinate2D center = ann.coordinate;
        
        if ((center.latitude >= -90) && (center.latitude <= 90) && (center.longitude >= -180) && (center.longitude <= 180)) {
            [annsArray addObject:ann];
        }
    }
    
    NSInteger count = [annsArray count];
    if ( count == 0) { return; } //bail if no annotations
    
    MKMapPoint points[count];
    for( int i=0; i < count; i++ ) {
        
        CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)[annsArray objectAtIndex:i] coordinate];
        points[i] = MKMapPointForCoordinate(coordinate);
    }
    
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
    
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    region.span.latitudeDelta  *= annotatonGrgionPadFactor;
    region.span.longitudeDelta *= annotatonGrgionPadFactor;
    
    if( region.span.latitudeDelta > maxDefreesARC ) { region.span.latitudeDelta  = maxDefreesARC; }
    if( region.span.longitudeDelta > maxDefreesARC ){ region.span.longitudeDelta = maxDefreesARC; }
    
    if( region.span.latitudeDelta  < minimunZoomARC ) { region.span.latitudeDelta  = minimunZoomARC; }
    if( region.span.longitudeDelta < minimunZoomARC ) { region.span.longitudeDelta = minimunZoomARC; }
    
    if( count == 1 ) {
        region.span.latitudeDelta = 0.014;
        region.span.longitudeDelta = 0.014;
    }
    [self.mapView setRegion:region animated:animated];
}

- (void)dealloc {
    
    [_mapView removeAnnotations:self.annotations];
    
    [_mapView removeFromSuperview];
    _mapView = nil;
   // dispatch_source_cancel(_timer);
}




#pragma mark -CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
//    if (self.realTimeLocation) {
//        
//        self.realTimeLocation(newLocation,nil);
//    }
    self.location = newLocation;
    
    NSLog(@"%f----%f",newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    [_mapView setCenterCoordinate:self.location.coordinate zoomLevel:13 animated:YES];
//    if (self.firstLocation && self.onceLocation) {
//        self.onceLocation(newLocation,nil);
//        self.firstLocation = NO;
    
//        [NetAPIManager postPhoneData:@{@"lat":@(newLocation.coordinate.latitude),@"lng":@(newLocation.coordinate.longitude)}];
   // }
}



- (MKAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier {
    
    return [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
}

- (MKAnnotationView *)viewForAnnotation:(id<MKAnnotation>)annotation {
    
    return [self.mapView viewForAnnotation:annotation];
}

#pragma mark - MKMapViewDelegate

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        
        if (!self.userView) {
            self.userView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"userLocationIdentifier"];
            self.userView.image = [UIImage imageNamed:@"定位"];
            [self.userView setTransform:CGAffineTransformMakeRotation(.001)];
        }
        
        return self.userView;
    }
    
    if ([annotation isKindOfClass:[KPAnnotation class]]) {
        
        KPAnnotation *pin = (KPAnnotation *)annotation;
        
            
            if (pin.isCluster) {
                
                ClusterAnnotationView * view = (ClusterAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ClusterAnnotationView"];
                if (!view) {
                    view = [[ClusterAnnotationView alloc] initWithAnnotation:pin reuseIdentifier:@"ClusterAnnotationView"];
                }
                
                
                view.countStr = [NSString stringWithFormat:@"%ld",pin.annotations.count]; //@().stringValue;
                
                NSLog(@"-----%@   %@",@(pin.annotations.count).stringValue,[view  class]);
                
                return view;
            }
        
        
        while ([pin isKindOfClass:[KPAnnotation class]]) {
            
            pin = [[pin.annotations allObjects] firstObject];
        }
        
        annotation = pin;
    }
    
    if (annotation) {
        
        ViewAnnView *customView = (ViewAnnView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"customView"];
        
        customView.delegate = self;
        if (!customView){
            customView =[[ViewAnnView alloc] initWithAnnotation:annotation reuseIdentifier:@"customView"];
          //  customView.delegate = self;
        }
        
        customView.annotation = annotation;
        
        return  customView;
    }
    
    return nil;
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    [self.mapView removeFromSuperview];
    [self.view addSubview:self.mapView];
    
    [self.clusteringController refresh:YES];
}

//实现划线的代理方法

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        
        MKPolylineRenderer * line = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        
        line.strokeColor = [UIColor redColor];
        line.lineWidth = 3.f;
        
        return line;
    }
    
    return nil;
}


#pragma mark --ViewAnnViewDelegate

- (void)tapAddLineWithPoint:(CLLocationCoordinate2D)coordinate {
    
    MKDirectionsRequest * request = [[MKDirectionsRequest alloc] init];
    
    CLLocationCoordinate2D coorself = self.location.coordinate;
    
    CLLocationCoordinate2D coorto = coordinate;
    
    //设置  起点
    
    MKPlacemark *from = [[MKPlacemark alloc] initWithCoordinate:coorself addressDictionary:nil];
    
    request.source = [[MKMapItem alloc] initWithPlacemark:from];
    
    // 设置  终点
    
    MKPlacemark * to = [[MKPlacemark alloc] initWithCoordinate:coorto addressDictionary:nil];
    
    request.destination = [[MKMapItem alloc] initWithPlacemark:to];
    
    request.requestsAlternateRoutes = YES;
    
    request.transportType = MKDirectionsTransportTypeWalking;//步行模式
    
    MKDirections * directions =  [[MKDirections alloc] initWithRequest:request];//方向对象  就是从哪儿到哪儿
    
    //计算路线
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
       
        [self.mapView removeOverlays:self.mapView.overlays];
        
        if (response.routes.count) {
            
            [self.mapView addOverlay:response.routes.firstObject.polyline];
        }else  {
            
           // [IGUtils showToast:@"没有路线或出现错误"];
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
