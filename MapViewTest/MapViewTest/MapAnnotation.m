//
//  MapAnnotation.m
//  MapViewTest
//
//  Created by ChenHao on 15/5/5.
//  Copyright (c) 2015年 ChenHao. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

-(id)initWithCoordinate:(CLLocationCoordinate2D) aCoordinate{
    if (self = [super init]) {
        self.coordinate = aCoordinate;
    }
    return  self;
}

@end
