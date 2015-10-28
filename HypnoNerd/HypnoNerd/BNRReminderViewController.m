//
//  BNRReminderViewController.m
//  HypnoNerd
//
//  Created by ChenHao on 15/9/14.
//  Copyright (c) 2015年 ChenHao. All rights reserved.
//

#import "BNRReminderViewController.h"

@interface BNRReminderViewController()

@property (nonatomic,weak) IBOutlet UIDatePicker *datePicker;

@end

@implementation BNRReminderViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //设置最小可以显示的时间
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:60];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"BNRReminderViewController viewDidLoad");
}

-(IBAction)addReminder:(id)sender {
    NSDate *date = self.datePicker.date;
    
    //设置一个本地通知
    UILocalNotification *note = [[UILocalNotification alloc] init];
    note.alertBody = @"Hypnotize me!";
    note.fireDate = date;
    
    //注册通知到应用
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
    
    NSLog(@"Setting a reminder for %@", date);
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Reminder";
        UIImage *i = [UIImage imageNamed:@"Time.png"];
        self.tabBarItem.image = i;
    }
    return self;
}
    

@end
