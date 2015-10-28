//
//  ViewController.m
//  HypnoNerd
//
//  Created by ChenHao on 15/9/14.
//  Copyright (c) 2015年 ChenHao. All rights reserved.
//

#import "BNRHypnosisViewController.h"

@interface BNRHypnosisViewController ()

@end

@implementation BNRHypnosisViewController


-(void)loadView {
    BNRHypnosisView *bgView = [[BNRHypnosisView alloc] init];
    self.view = bgView;
    
    CGRect textFieldRect = CGRectMake(40, 70, 240, 30);
    
    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldRect];
    
    textField.borderStyle = UITextBorderStyleRoundedRect;
    
    textField.placeholder = @"Hypnotize me";
    
    textField.returnKeyType = UIReturnKeyDone;
    
    textField.delegate = self;
    
    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    
    textField.autocorrectionType = UITextAutocorrectionTypeYes;
    textField.enablesReturnKeyAutomatically = YES;
//    textField.secureTextEntry = YES;
    
    [bgView addSubview:textField];
    
    NSLog(@"BNRHypnosisViewController loadView");
}

-(void)drawHypnoticMessage:(NSString *)message {
    for (int i = 0; i < 20; i++) {
        UILabel *messageLabel = [[UILabel alloc] init];
        //设置label 的文字和颜色
        messageLabel.backgroundColor = [UIColor clearColor];
        
        messageLabel.textColor = [UIColor whiteColor];
        
        messageLabel.text = message;
        
        //根据需要显示的文字调整UILabel对象的大小
        [messageLabel sizeToFit];
        
        //获取随机x坐标
        
        //使用UILabel对象的宽度不超过view的宽度
        int width = (int)(self.view.bounds.size.width - messageLabel.bounds.size.width);
        int x = arc4random() % width;
        
        //获取随机y坐标
        
        //使UILabel对象的高度不超过view高度
        int height = (int)(self.view.bounds.size.height - messageLabel.bounds.size.height);
        
        int y = arc4random() % height;
        
        //设置UILabel对象的frame
        
        CGRect frame = messageLabel.frame;
        
        frame.origin = CGPointMake(x, y);
        
        messageLabel.frame = frame;
        
        //将UILabel 对象添加到view中
        [self.view addSubview:messageLabel];
        
        //为UILabel添加视差效果
        UIInterpolatingMotionEffect *motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        motionEffect.minimumRelativeValue = @(-25);
        
        motionEffect.maximumRelativeValue = @(25);
        
        [messageLabel addMotionEffect:motionEffect];
        
        motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        
        motionEffect.minimumRelativeValue = @(-25);
        
        motionEffect.maximumRelativeValue = @(25);
        
        [messageLabel addMotionEffect:motionEffect];
    }
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //设置标签项的标题
        self.tabBarItem.title = @"Hypnotize";
        
        //在Retina显示屏上会加载Hypno@2x.png，而不是Hypno.png
        UIImage *i = [UIImage imageNamed:@"Hypno.png"];
        
        //将UIImage对象赋给标签项的image属性
        self.tabBarItem.image = i;
    }
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"%@",textField.text);
    
    [self drawHypnoticMessage:textField.text];
    
    textField.text = @"";
    
    [textField resignFirstResponder];
    
    
    
    
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
