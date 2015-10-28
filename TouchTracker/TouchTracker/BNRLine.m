//
//  BNRLine.m
//  TouchTracker
//
//  Created by ChenHao on 15/9/28.
//  Copyright (c) 2015年 ChenHao. All rights reserved.
//

#import "BNRLine.h"

@implementation BNRLine

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:NSStringFromCGPoint(_begin) forKey:@"begin"];
    [aCoder encodeObject:NSStringFromCGPoint(_end) forKey:@"end"];
    [aCoder encodeObject:_lineColor forKey:@"color"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.begin = CGPointFromString([aDecoder decodeObjectForKey:@"begin"]);
        self.end = CGPointFromString([aDecoder decodeObjectForKey:@"end"]);
        self.lineColor = [aDecoder decodeObjectForKey:@"color"];
    }
    return self;
}

@end
