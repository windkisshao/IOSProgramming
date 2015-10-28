//
//  BNRDetailViewController.h
//  Homepwner
//
//  Created by ChenHao on 15/9/23.
//  Copyright (c) 2015年 ChenHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface BNRDetailViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

@property(nonatomic,strong) BNRItem *item;

@end
