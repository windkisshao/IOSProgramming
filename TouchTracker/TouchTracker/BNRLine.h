//
//  BNRLine.h
//  TouchTracker
//
//  Created by ChenHao on 15/9/28.
//  Copyright (c) 2015年 ChenHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BNRLine : NSObject<NSCoding>

@property (nonatomic) CGPoint begin;

@property (nonatomic) CGPoint end;

@property (nonatomic) UIColor *lineColor;

@property (nonatomic,strong) NSMutableArray *containingArray;

@property (nonatomic) float width;

@end
