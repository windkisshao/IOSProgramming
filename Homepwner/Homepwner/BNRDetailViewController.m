//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by ChenHao on 15/9/23.
//  Copyright (c) 2015年 ChenHao. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRItem.h"
#import "DateChangeViewController.h"
#import "BNRImageStore.h"
#import "CrossLine.h"
@import MobileCoreServices;

@interface BNRDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;

@property (weak, nonatomic) IBOutlet UITextField *serialField;

@property (weak, nonatomic) IBOutlet UITextField *valueField;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation BNRDetailViewController

- (IBAction)changeDate:(UIButton *)sender {
    DateChangeViewController *ctrler = [[DateChangeViewController alloc] init];
    ctrler.item = _item;
    [self.navigationController pushViewController:ctrler animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    BNRItem *item = self.item;
    
    self.nameField.text = item.itemName;
    
    self.serialField.text = item.serialNumber;
    
    self.valueField.text = [NSString stringWithFormat:@"%d",item.valueInDollars];
    
    //创建NSDateFormatter 对象，用于将NSDate对象转换成简单的日期字符串
    static NSDateFormatter *dateFormatter = nil;
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateIntervalFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    self.detailLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    
    NSString *itemKey = self.item.itemKey;
    
    //根据itemKey，从BNRImageStore对象获取照片
    UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:itemKey];
    self.imageView.image = imageToDisplay;
    
}

- (IBAction)deletePic:(id)sender {
    [[BNRImageStore sharedStore] deleteImageForKey:self.item.itemKey];
    self.imageView.image = nil;
}


- (IBAction)hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)takePicture:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    //判断设备是否支持相机，支持就用相机，否则选择图库
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    //额外说明：限制用户只能选择拍照很简单，保留mediaTypes的默认值即可，允许用户在拍照和视频之间做一个选择也很简单（将mediaType设置为availableMediaTypesForSourceType），但是要限制用户只使用视频，则先需要确定设备是否支持视频，然后设置mediaTypes属性指向一个只包含视频标识的数组对象。
    
    NSArray *availableTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    
    //下面是判断设备是否支持视频录制，如果支持，设置mediaType为视频模式
//    if ([availableTypes containsObject: (__bridge NSString*) kUTTypeMovie]) {
//        [imagePicker setMediaTypes:@[(__bridge NSString*)kUTTypeMovie]];
//    }
    
    imagePicker.mediaTypes = availableTypes;
    
    CrossLine *crossLine = [[CrossLine alloc] init];
    
    crossLine.frame = CGRectMake(0, 0, 100, 100);
    
    crossLine.center = self.view.center;
    
    crossLine.backgroundColor = [UIColor clearColor];

    
    imagePicker.cameraOverlayView =crossLine;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //通过info字典获取选择的照片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    NSURL *mediaURL = info[UIImagePickerControllerMediaURL];
    
    if (mediaURL) {
        //确定设备是否支持视频
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([mediaURL path])) {
            //将视频存入相册
            UISaveVideoAtPathToSavedPhotosAlbum([mediaURL path], nil, nil, nil);
            //删除临时目录下的视频
            [[NSFileManager defaultManager]removeItemAtPath:[mediaURL path] error:nil];
        }
    }
    
    //以itemKey为键，将照片存入BNRImageStore对象
    [[BNRImageStore sharedStore] setImage:image forKey:_item.itemKey];
    
    //将照片放入UIImageView对象
    self.imageView.image = image;
    
    //关闭UIImagePickerController对象
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //关闭UIImagePickerController对象
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)setItem:(BNRItem *)item {
    _item = item;
    self.navigationItem.title = _item.itemName;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //取消当前的第一响应对象
    [self.view endEditing:YES];
    
    //将修改保存至BNRItem对象
//    BNRItem *item = self.item;
    self.item.itemName = self.nameField.text;
    
    self.item.serialNumber = self.serialField.text;
    
    self.item.valueInDollars = [self.valueField.text intValue];
    
}







@end
