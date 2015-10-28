//
//  MapAnnotation.h
//  MapViewTest
//
//  Created by ChenHao on 15/5/5.
//  Copyright (c) 2015年 ChenHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject<MKAnnotation>

@property(nonatomic)CLLocationCoordinate2D coordinate;

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *subtitle;

#pragma mark 自定义一个图片属性在创建大头针视图时使用
@property (nonatomic,retain) UIImage *image;

-(id)initWithCoordinate:(CLLocationCoordinate2D) aCoordinate;

@end
