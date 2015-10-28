//
//  BNRDrawView.m
//  TouchTracker
//
//  Created by ChenHao on 15/9/28.
//  Copyright (c) 2015年 ChenHao. All rights reserved.
//

#import "BNRDrawView.h"
#import "BNRLine.h"

#define pi 3.14159265358979323846
#define degreesToRadian(x) (pi * x / 180.0)
#define radiansToDegrees(x) (180.0 * x / pi)

@interface BNRDrawView ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIPanGestureRecognizer *moveRecognizer;

@property (nonatomic,strong) BNRLine *currentLine;

@property (nonatomic,strong) NSMutableArray *finishedLines;

@property (nonatomic,strong) NSMutableDictionary *linesInProgress;

@property (nonatomic,weak) BNRLine *selectedLine; //设置为弱引用，原因：首先，finishedLines 数组会保存selectedLine，是强引用；其次，如果用户清除所有线条，finishedLines会移除selectedLine，这时BNRDrawView会自动将selectedLine设置nil。

@property (strong, nonatomic) IBOutlet UIView *colorView;

@property (nonatomic) UIColor *selectedColor;

@property (nonatomic) UITextView *textView;

@property (nonatomic) UIToolbar *inputAccessoryView;

@end

@implementation BNRDrawView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *path = [documents[0] stringByAppendingPathComponent:@"lines.plist"];
        
        //恢复归档的线条
        NSArray *lines = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (lines) {
            self.finishedLines = [NSMutableArray arrayWithArray:lines];
        } else {
            self.finishedLines = [[NSMutableArray alloc] init];
        }
        
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        
        self.backgroundColor = [UIColor grayColor];
        
        self.multipleTouchEnabled = YES;
        
        UITapGestureRecognizer *douleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        
        douleTapRecognizer.numberOfTapsRequired = 2;
        
        douleTapRecognizer.delaysTouchesBegan = YES;//延迟touchBegin:withEvent:消息
        
        [self addGestureRecognizer:douleTapRecognizer];
        
        
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tapRecognizer.delaysTouchesBegan = YES;
        //设置单击后暂时不识别，直到确定不是双击事件后再识别为单击手势
        [tapRecognizer requireGestureRecognizerToFail:douleTapRecognizer];
        [self addGestureRecognizer:tapRecognizer];
        
        UILongPressGestureRecognizer *pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:pressRecognizer];
        
        self.moveRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLine:)];
        self.moveRecognizer.delegate = self;
        self.moveRecognizer.cancelsTouchesInView = NO;//该属性默认YES，当某个UIGestureRecognizer对象的cancelsTouchesInView属性为YES时，这个对象会在识别出特定的手势时，“吃掉”所有和该手势相关的UITouch对象。这样，该对象所依附的UIView对象将不会收到UIResponder消息，譬如 touchesBegan:withEvent:。
        [self addGestureRecognizer:self.moveRecognizer];
        
        
        UISwipeGestureRecognizer *threeFingerSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(displayPanel:)];
        [threeFingerSwipe setDirection:UISwipeGestureRecognizerDirectionUp];
        [threeFingerSwipe setNumberOfTouchesRequired:3];
        [threeFingerSwipe setDelaysTouchesBegan:YES];
        [self addGestureRecognizer:threeFingerSwipe];
        
        
//        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(100, 100,200, 200)];
//        [self.textView becomeFirstResponder];
//        self.textView.inputAccessoryView = _inputAccessoryView;
//        [self addSubview:self.textView];
    }
    return self;
}

//-(UIToolbar *)inputAccessoryView {
//    if (!_inputAccessoryView) {
//        _inputAccessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
//        
//        UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(dodo)];
//        
//        UIBarButtonItem *eidt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(dodo)];
//        
//        UIBarButtonItem *book = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(dodo)];
//        
//        _inputAccessoryView.items = @[add,eidt,book];
//        [_inputAccessoryView setAutoresizesSubviews:YES];
//    }
//    return _inputAccessoryView;
//    
//}

-(void)dodo {
    [self resignFirstResponder];
}

-(void)moveLine:(UIPanGestureRecognizer *)gr {
    //如果没有选中的线条就直接返回
    if (!self.selectedLine) {
        return;
    }
    //如果UIPanGestureRecognizer对象处于变化的状态
    if (gr.state == UIGestureRecognizerStateChanged) {
        //获取手指的拖移距离
        CGPoint translation = [gr translationInView:self];
        
        //将拖移距离加至选中的线条的起点和终点
        CGPoint begin = self.selectedLine.begin;
        
        CGPoint end = self.selectedLine.end;
        
        begin.x += translation.x;
        
        begin.y += translation.y;
        
        end.x += translation.x;
        
        end.y += translation.y;
        
        //为选中的线条设置新的起点和终点
        self.selectedLine.begin = begin;
        
        self.selectedLine.end = end;
        
        //重画视图
        [self setNeedsDisplay];
        
        //使对象增量的报告拖移距离
        [gr setTranslation:CGPointZero inView:self];
    }
    
    //第二种解决方法，在moveLine里面判断，如果移动这个动作状态判定为开始，selectedLine改为动作所在位置，Menu改为不可见
//    if ([gr state] == UIGestureRecognizerStateBegan) {
//        self.selectedLine = [self lineAtPoint:[gr locationInView:self]];
//        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
//    }
}

//如果menu可见，就把他设置成不可见，把选中的线设置为nil
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([[UIMenuController sharedMenuController] isMenuVisible]) {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
        self.selectedLine = nil;
    }
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //如果方法返回yes，那么当前的UIGestureRecognizer子类对象就会和其他UIGestureRecognizer子类对象共享UITouch对象,如果消息发送方是moveRecognizer，就返回YES，否则返回NO
    if (gestureRecognizer == self.moveRecognizer) {
        return YES;
    }
    return NO;
}

-(void)longPress:(UIGestureRecognizer *)gr {
    if (gr.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gr locationInView:self];
        self.selectedLine = [self lineAtPoint:point];
        if (self.selectedLine) {
            [self.linesInProgress removeAllObjects];
        } else if (gr.state == UIGestureRecognizerStateEnded) {
            self.selectedLine = nil;
        }
        [self setNeedsDisplay];
    }
}

-(void)tap:(UIGestureRecognizer *)gr {
    NSLog(@"Recognized tap");
    
    CGPoint point = [gr locationInView:self];
    
    self.selectedLine = [self lineAtPoint:point];
    
    if (self.selectedLine) {
        //是视图成为UIMenuItem动作消息的目标
        [self becomeFirstResponder];
        
        //获取UIMenuController对象,每个iOS应用只有一个UIMenuController对象
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        //创建一个新的标题为“Delete”的UIMenuItem对象
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteLine:)];
        
        menu.menuItems = @[deleteItem];
        
        //先为UIMenuController对象设置显示区域，然后将其设置为可见
        
        [menu setTargetRect:CGRectMake(point.x, point.y, 2, 2) inView:self];
        
        [menu setMenuVisible:YES animated:YES];
    } else {
        //如果没有选中线条，就隐藏UIMenuController对象
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
    
    [self setNeedsDisplay];
}

//如果要将自定义的UIView子类对象设置为第一个响应者对象，就必须覆盖该对象的canBecomeFirstResponder方法
-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void) deleteLine:(id)sender {
    //从已经完成的线条中删除选中的线条
    [self.finishedLines removeObject:self.selectedLine];
    //重绘视图
    [self setNeedsDisplay];
}

-(void)doubleTap:(UIGestureRecognizer *)gr {
    NSLog(@"Recognized Double Tap");
    
    [self.linesInProgress removeAllObjects];
    
//    [self.finishedLines removeAllObjects];
    
    self.finishedLines = [NSMutableArray array];
    
    [self setNeedsDisplay];
}

- (void) strokeLine: (BNRLine *)line withWidth:(float)width{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    
    bp.lineWidth = width;
    
    bp.lineCapStyle = kCGLineCapRound;
    
    [bp moveToPoint:line.begin];
    
    [bp addLineToPoint:line.end];
    
    [bp stroke];
    
}

-(void)drawRect:(CGRect)rect {
    //用黑色绘制已经完成的线条
//    [[UIColor blackColor] set];
    
    for (BNRLine *line in self.finishedLines) {
        [line.lineColor set];
        [self strokeLine:line withWidth:line.width];
    }
    
    //用红色绘制正在画的线条
    [[UIColor redColor] set];
    
    for (NSValue *key in self.linesInProgress) {
        BNRLine *line = self.linesInProgress[key];
        [self strokeLine:line withWidth:line.width];
    }
    
    if (self.selectedLine) {
        [[UIColor greenColor] set];
        [self strokeLine:self.selectedLine withWidth:self.selectedLine.width];
    }
    
//    if (self.currentLine) {
//          //用红色绘制正在画的线条
//        [[UIColor redColor] set];
//
//        [self strokeLine:self.currentLine];
//    }

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //向控制台输出日志，查看触摸事件发生顺序
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    
    
    for (UITouch *t in touches) {
        //根据触摸位置创建BNRLine对象
        
        CGPoint location = [t locationInView:self];
        
        BNRLine *line = [[BNRLine alloc] init];
        
        line.begin = location;
        
        line.end = location;
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        
        self.linesInProgress[key] = line;
        
        [self.colorView removeFromSuperview];
        
    }
    
    
//    UITouch *t = [touches anyObject];
//    
//    CGPoint location = [t locationInView:self];
//    
//    self.currentLine = [[BNRLine alloc] init];
//    
//    self.currentLine.begin = location;
//    
//    self.currentLine.end = location;

    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //向控制台输出日志，查看触摸事件发生顺序
//    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
  
        BNRLine *line = self.linesInProgress[key];
        
        //获得手势在view里面移动的速度
        CGPoint velocity = [self.moveRecognizer velocityInView:self];
        
        line.width = (fabs(velocity.x) + fabs(velocity.y)) / 25.0;
        
        NSLog(@"%f",line.width);

        line.end = [t locationInView:self];
        
//        BNRLine *line = self.firstDic[key];
//        
//        if (line) {
//            line.end = [t locationInView:self];
//        } else {
//            line = self.secondDic[key];
//            line.end = [t locationInView:self];
//        }
        
    }
    
//    UITouch *t = [touches anyObject];
//    
//    CGPoint location = [t locationInView:self];
//    
//    self.currentLine.end = location;
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //向控制台输出日志，查看触摸事件发生顺序
//    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    BNRLine *firstLine = [[BNRLine alloc] init];
    
    BNRLine *secondLine = [[BNRLine alloc] init];
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        
//        firstLine = self.firstDic[key];
//        
//        secondLine = self.secondDic[key];

        BNRLine *line = self.linesInProgress[key];
        
        CGFloat angle = [self angleBetweenPoints:line.begin Second:line.end];
        NSLog(@"角度。。。。 %lf",angle);
        
        if (angle < 0) {
            angle = 0 - angle;
        }
        
//        line.lineColor = [UIColor colorWithRed:angle/155 green:angle/200 blue:angle/120 alpha:1.000];
        line.lineColor = self.selectedColor;
        
        [self.finishedLines addObject:line];
        
        [self.linesInProgress removeObjectForKey:key];
        
        line.containingArray  = self.finishedLines;
    
    }
//    
//    CGPoint firstHalf = CGPointMake((firstLine.begin.x + firstLine.end.x) / 2.0, (firstLine.begin.y + firstLine.begin.y) / 2.0);
//    
//    CGPoint secondHalf = CGPointMake((secondLine.begin.x + secondLine.end.x) / 2.0, (secondLine.begin.y + secondLine.begin.y) / 2.0);
//    
//    CGPoint center = CGPointMake((firstHalf.x + secondHalf.x) / 2.0, (firstHalf.y + secondHalf.y) / 2.0);
//    
//    float width = secondHalf.x - firstHalf.x;
//    
//    if (width < 0) {
//        width = 0 - width;
//    }
//    
//    float height = secondHalf.y - firstHalf.y;
//    
//    if (height < 0) {
//        height = 0 - height;
//    }
//    
//    float radius = hypotf(width, height) / 2.0;
//    
//    UIBezierPath *path = [[UIBezierPath alloc] init];
//    
//    [path moveToPoint:CGPointMake(center.x + radius, center.y)];
//    
//    [path addArcWithCenter:center radius:radius startAngle:0 endAngle:M_PI * 2.0 clockwise:YES];
    
//    [self.finishedLines addObject:self.currentLine];
//    
//    self.currentLine = nil;
    
    //把线条信息归档
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *path = [documents[0] stringByAppendingPathComponent:@"lines.plist"];
    
    [NSKeyedArchiver archiveRootObject:self.finishedLines toFile:path];
    
    [self setNeedsDisplay];
}

-(CGFloat) angleBetweenPoints:(CGPoint)first Second:(CGPoint)second {
    CGFloat height = second.y - first.y ;
    CGFloat width = first.x - second.x;
    CGFloat rads = atan(height / width);
    return radiansToDegrees(rads);
}

//如果要实现某个UIResponderStandardEditAction协议中的方法，又不希望UIMenuController对象显示对应的菜单项，可以覆盖这个方法，然后针对特定的方法返回NO
//-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//    if (action == @selector(copy:)) {
//        return NO;
//    }
    //父类的实现会根据目标对象是否实现了特定的动作方法，返回YES或NO
//    return [super canPerformAction:action withSender:sender];
//}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    //向控制台输出日志，查看触摸事件发生顺序
//    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}

- (BNRLine *)lineAtPoint:(CGPoint) p {
    //找出离p最近的BNRLine对象
    for (BNRLine *l in self.finishedLines) {
        CGPoint start = l.begin;
        CGPoint end = l.end;
        
        //检查线条的若干点
        
        for (float t = 0.0 ; t <= 1.0; t+=0.05) {
            float x = start.x + t * (end.x - start.x);
            
            float y = start.y + t * (end.y - start.y);
            
            //如果线条的某个点和p的距离在20点以内，就返回相应的BNRLine对象
            
            if (hypot(x - p.x, y - p.y) < 20.0) {
                return l;
            }
        }
    }
    return nil;
}

- (int) numberOfLines {
    int count = 0;
    
    //计数前先查看相应的指针是否为nil
    if (self.linesInProgress && self.finishedLines) {
        count = self.linesInProgress.count + self.finishedLines.count;
    }
    return count;
}

-(void)displayPanel:(UIGestureRecognizer *)gr {
    NSLog(@"swiped up");
    
    CGRect frame = CGRectMake(0, self.window.frame.size.height - 550, self.window.frame.size.width, 50);
    NSLog(@"%@",NSStringFromCGRect(frame));
    
    [[NSBundle mainBundle] loadNibNamed:@"colorView" owner:self options:nil];
    
    UIView *colorSelect = self.colorView;
    self.colorView.frame = frame;
    self.colorView.backgroundColor = [UIColor grayColor];
    [self.window addSubview:colorSelect];
    [self.window setNeedsDisplay];
    
}

- (IBAction)selectedColor:(UIButton *)sender {
    self.selectedColor = sender.backgroundColor;
    [self.colorView  removeFromSuperview];
}



@end
