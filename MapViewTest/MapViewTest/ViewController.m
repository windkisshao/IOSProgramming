//
//  ViewController.m
//  MapViewTest
//
//  Created by ChenHao on 15/5/5.
//  Copyright (c) 2015年 ChenHao. All rights reserved.
//

#import "ViewController.h"
#import "MapAnnotation.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController()<CLLocationManagerDelegate,MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    float deviceVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (deviceVersion >= 8.0) {
        [self.locationManager requestWhenInUseAuthorization];//使用时
    }
    if ([CLLocationManager locationServicesEnabled]) {
          [self.locationManager startUpdatingLocation];
    } else {
        NSLog(@"定位不可用");
    }
   self.mapView.delegate = self;
    [self addAnnotation];
    CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(39.95, 116.35);
    [self.mapView setRegion:MKCoordinateRegionMake(location1, MKCoordinateSpanMake(0.005f, 0.005f)) animated:YES];
    [self.mapView setCenterCoordinate:location1];
    
    
}

-(void)addAnnotation{
    CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(39.95, 116.35);
    MapAnnotation *annotation = [[MapAnnotation alloc] initWithCoordinate:location1];
    annotation.title = @"Sherlock";
    annotation.subtitle = @"Barker Street 222B";
    annotation.image = [UIImage imageNamed:@"icon_school_track"];
    [self.mapView addAnnotation:annotation];
    
    CLLocation *locationCll = [[CLLocation alloc] initWithLatitude:location1.latitude longitude:location1.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:locationCll completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *mark = [placemarks objectAtIndex:0];
        NSLog(@"终极目标:%@%@%@%@", mark.locality, mark.subLocality,mark.thoroughfare,mark.subThoroughfare);
    }];
    
    CLLocationCoordinate2D location2=CLLocationCoordinate2DMake(39.87, 116.35);
    MapAnnotation *annotation2=[[MapAnnotation alloc]init];
    annotation2.title=@"Kenshin&Kaoru";
    annotation2.subtitle=@"Kenshin Cui's Home";
    annotation2.coordinate=location2;
    annotation2.image = [UIImage imageNamed:@"icon_school_track"];
    [_mapView addAnnotation:annotation2];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MapAnnotation class]]) {
        static NSString *key1 = @"AnnotationKey1";
        MKAnnotationView *view = [self.mapView dequeueReusableAnnotationViewWithIdentifier:key1];
        
        if (!view) {
            view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:key1];
            view.canShowCallout = YES;
            view.calloutOffset = CGPointMake(0, 1);
        }
        
        view.annotation = annotation;
        view.image = ((MapAnnotation *)annotation).image;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
        [btn setBackgroundColor:[UIColor redColor]];
        [view addSubview:btn];
        return view;
    }
    return nil;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [self.locationManager requestWhenInUseAuthorization];
            }
            break;
        default:
            break;
            
            
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"location manager error : %@ ", [error description]);
    [self.locationManager stopUpdatingLocation];
    return;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    self.mapView.userLocation.title = @"Location Coordinate";
    self.mapView.userLocation.subtitle = [NSString stringWithFormat:@"%f, %f",self.mapView.userLocation.location.coordinate.latitude,self.mapView.userLocation.location.coordinate.longitude];
    self.mapView.showsUserLocation = YES;
    self.mapView.zoomEnabled = YES;
    
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    [views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MKPinAnnotationView *view = (MKPinAnnotationView *)obj;
//        if ([view.annotation title]) {
//            <#statements#>
//        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
