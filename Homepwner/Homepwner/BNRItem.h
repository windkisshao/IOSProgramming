//
//  BNRItem.h
//  RandomItems
//
//  Created by ChenHao on 15/9/1.
//  Copyright (c) 2015年 ChenHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject {
    NSString *_itemName;
    
    NSString *_serialNumber;
    
    int _valueInDollars;
    
}

@property(nonatomic) NSDate *dateCreated;

@property(nonatomic,copy) NSString *itemKey;

//BNRItem类的指定初始化方法
-(instancetype)initWithItemName:(NSString *) itemName valueInDollars:(int)value serialNumber:(NSString *)sNumber;

-(instancetype)initWithItemName:(NSString *)name;

-(instancetype)initWithItemName:(NSString *)name serialNumber:(NSString *)sNumber;

-(void)setItemName:(NSString *)itemName;

-(NSString *)itemName;

-(void)setSerialNumber:(NSString *)serialNumber;

-(NSString *)serialNumber;

-(void)setValueInDollars:(int)dolloars;

-(int)valueInDollars;

+(instancetype)randomItem;




@end
