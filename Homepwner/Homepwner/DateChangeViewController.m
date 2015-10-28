//
//  DateChangeViewController.m
//  Homepwner
//
//  Created by ChenHao on 15/9/24.
//  Copyright (c) 2015年 ChenHao. All rights reserved.
//

#import "DateChangeViewController.h"
#import "BNRItem.h"

@interface DateChangeViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;


@end

@implementation DateChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _datePicker.date = _item.dateCreated;
    // Do any additional setup after loading the view from its nib.
}

-(void)setItem:(BNRItem *)item {
    _item = item;
    
}
- (IBAction)datePicker:(UIDatePicker *)sender {
    NSDate *date = sender.date;
    _item.dateCreated = date;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
