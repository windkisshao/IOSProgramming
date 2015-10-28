//
//  CrossLine.m
//  Homepwner
//
//  Created by ChenHao on 15/9/25.
//  Copyright (c) 2015年 ChenHao. All rights reserved.
//

#import "CrossLine.h"

@implementation CrossLine


- (void)drawRect:(CGRect)rect {
    UIBezierPath *myCross = [[UIBezierPath alloc] init];
    [myCross moveToPoint:CGPointMake(self.frame.size.width/2.0, 0)];
    
    [myCross addLineToPoint:CGPointMake(self.frame.size.width / 2.0, self.frame.size.height)];
    
    [myCross moveToPoint:CGPointMake(0, self.frame.size.height / 2.0)];
    
    [myCross addLineToPoint:CGPointMake(self.frame.size.width,  self.frame.size.height / 2.0)];
    
    [[UIColor whiteColor] setStroke];
    
    [myCross stroke];
}


@end
