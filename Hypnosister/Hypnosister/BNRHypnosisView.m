//
//  BNRHypnosisView.m
//  Hypnosister
//
//  Created by ChenHao on 15/9/9.
//  Copyright (c) 2015年 ChenHao. All rights reserved.
//

#import "BNRHypnosisView.h"

@interface BNRHypnosisView()

@property (strong,nonatomic)UIColor *circleColor;

@end

@implementation BNRHypnosisView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.circleColor = [UIColor lightGrayColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    CGRect bounds = self.bounds;
    
    //根据bounds计算中心点
    CGPoint center;
    
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    
    center.y = bounds.origin.y + bounds.size.height / 2.0;

    //根据视图宽和高的较小值计算圆形的半径
//    float radius = (MIN(bounds.size.width, bounds.size.height) / 2.0);
    
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0; //hypot 计算三角形的斜边
    
    //UIBezierPath 类绘制直线或曲线，从而组成各种形状
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius-=20) {
        
        //挪动画笔
        [path moveToPoint:CGPointMake(center.x + currentRadius, center.y)];
        
        [path addArcWithCenter:center radius:currentRadius startAngle:0 endAngle:M_PI * 2.0 clockwise:YES];
    }
    
//    [path addArcWithCenter:center radius:radius startAngle:0 endAngle:M_PI * 2.0 clockwise:YES];
    //设置线条宽度为10点
    path.lineWidth = 10;
    
    //设置绘制颜色为浅灰色
    [[UIColor lightGrayColor] setStroke];
    
    [self.circleColor setStroke];
    
    //绘制路径
    [path stroke];
    
//    CGPoint a = CGPointMake(20, 30);
//    CGPoint b = CGPointMake(60, 60);
//    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
//    CGContextSetRGBStrokeColor(currentContext, 1, 0, 0, 1);
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, NULL, a.x, a.y);
//    CGPathAddLineToPoint(path, NULL, b.x, b.y);
//    CGContextAddPath(currentContext, path);
//    CGContextStrokePath(currentContext);
//    CGPathRelease(path);
    
    
    //在这里绘制的图像没有阴影效果
    UIImage *logo = [UIImage imageNamed:@"logo"];
//    [logo drawInRect:CGRectMake(30, 20, 40, 40)];
   
    //绘制渐变
//    CGFloat locations[3] = {0.0,0.5,1.0};
//    
//    CGFloat components[12] = {1.0,0.0,0.0,1.0,0.0,1.0,0.0,1.0,
//        1.0,1.0,0.0,1.0};
//    
//    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
//    
//    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, 3);
//    CGPoint startPoint = CGPointMake(50, 50);
//    CGPoint endPoint = CGPointMake(150, 150);
//    
//    CGContextDrawLinearGradient(currentContext, gradient, startPoint, endPoint, 0);
//    CGGradientRelease(gradient);
//    CGColorSpaceRelease(colorspace);
    
    
    //创建一个新路径（剪切路径，因为使用渐变会直接填充上下文）
    UIBezierPath *myPath = [[UIBezierPath alloc] init];
    
    [myPath moveToPoint:CGPointMake(80,600)];
    
    [myPath addLineToPoint:CGPointMake(300, 600)];
    
    [myPath addLineToPoint:CGPointMake(190, 100)];
    
    [myPath addLineToPoint:CGPointMake(80, 600)]; //创建一个三角形路径
    
    CGContextSaveGState(currentContext); //保存上下文状态
    
    [myPath addClip]; //将myPath设置为当前上下文的剪切路径
    
    //在这里为myPath填充渐变
    CGFloat locations[2] = {0.0,1.0};
    
    CGFloat components[8] = {1.0,1.0,0.0,1.0,0.0,1.0,0.0,1.0};
    
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, 2);
    
    CGPoint startPoint = CGPointMake(80, 600); //这里填充的起点和终点x值相同
    CGPoint endPoint = CGPointMake(80, 100);
    
    CGContextDrawLinearGradient(currentContext, gradient, startPoint, endPoint, 0);
    
    CGContextRestoreGState(currentContext); //恢复上下文状态
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    
    [myPath stroke];
    
    CGContextSaveGState(currentContext); //保存上下文状态
    CGContextSetShadow(currentContext, CGSizeMake(4, 7), 3); //先设置效果后添加图像
    
    //在这里绘制的图像会带有阴影效果
    UIImage *logoImage = [UIImage imageNamed:@"logo"];
    [logoImage drawInRect:CGRectMake(30, 30, 320, 480)];
    
    CGContextRestoreGState(currentContext); //还原上下文状态

    
}

- (NSArray *)subEmoijString:(NSString *)orginalStr andLength:(int)length {
    NSString *str = [orginalStr substringWithRange:NSMakeRange(0, length)];
    while (![str UTF8String]) {
        str = [orginalStr substringToIndex:length - 1];
        length--;
    }
    
    NSString *leftStr = @"";
    if (orginalStr.length > length) {
        leftStr = [orginalStr substringFromIndex:length];
    }
    
    return @[str,leftStr];
}

//被触摸时会收到该消息
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%@ was touched",self);
    
    //获取三个0到1的数字
    float red = (arc4random() % 100) / 100.0;
    
    float green = (arc4random() % 100) / 100.0;
    
    float blue = (arc4random() % 100) / 100.0;
    
    UIColor *randomColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    self.circleColor = randomColor;
    
    //自定义的UIView子类，必须手动向图层发送setNeedsDisplay消息
    [self setNeedsDisplay]; //重绘
    
//    [self setNeedsDisplayInRect:<#(CGRect)#>] //重绘指定区域的视图
    
//    NSString *str = @"dsdsdsdsdsds";
//    
//    NSArray *arr = [self subEmoijString:str andLength:12];
//    
//    NSLog(@"前面的：%@，后面的：%@",arr[0],arr[1]);
    
}

@end
