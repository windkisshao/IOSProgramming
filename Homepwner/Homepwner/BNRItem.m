//
//  BNRItem.m
//  RandomItems
//
//  Created by ChenHao on 15/9/1.
//  Copyright (c) 2015年 ChenHao. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem

+(instancetype)randomItem {
    NSArray *randomAdjectiveList = @[@"Fluffy",@"Rusty",@"Shiny"];
    
    NSArray *randomNounList = @[@"Bear",@"Spork",@"Mac"];
    
    NSInteger adjectiveIndex = arc4random() % randomAdjectiveList.count;
    
    NSInteger nounIndex = arc4random() % randomNounList.count;
    
    NSString *randomName = [NSString stringWithFormat:@"%@%@",[randomAdjectiveList objectAtIndex:adjectiveIndex],[randomNounList objectAtIndex:nounIndex]];
    
    int randomValue = arc4random() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",'0'+arc4random()%10,'A'+arc4random()%26,'0'+arc4random()%10,'A'+arc4random()%26,'0'+arc4random()%10];
    
    BNRItem *newItem = [[self alloc] initWithItemName:randomName valueInDollars:randomValue serialNumber:randomSerialNumber];
    
    return newItem;
    
}

-(instancetype)initWithItemName:(NSString *)itemName valueInDollars:(int)value serialNumber:(NSString *)sNumber {
    self = [super init];
    if (self) {
        //为实例变量设定初始值
        _itemName = itemName;
        _valueInDollars = value;
        _serialNumber = sNumber;
        //设置_dateCreated的值为系统当前时间
        _dateCreated = [[NSDate alloc] init];
        
        //创建一个NSUUID对象，然后获取其NSString类型的值
        NSUUID *uuid = [[NSUUID alloc] init];
        _itemKey = [uuid UUIDString];
    }
    
    return self;
}

-(instancetype)initWithItemName:(NSString *)name {
    return [self initWithItemName:name valueInDollars:0 serialNumber:@""];
}

-(instancetype)init {
    return [self initWithItemName:@"item"];
}

-(instancetype)initWithItemName:(NSString *)name serialNumber:(NSString *)sNumber {
    return [self initWithItemName:name valueInDollars:0 serialNumber:sNumber];
}

-(void)setItemName:(NSString *)itemName {
    _itemName = itemName;
}

-(NSString *)itemName {
    return _itemName;
}

-(void)setSerialNumber:(NSString *)serialNumber {
    _serialNumber = serialNumber;
}

-(NSString *)serialNumber {
    return _serialNumber;
}

-(void)setValueInDollars:(int)dolloars {
    _valueInDollars = dolloars;
}

-(int)valueInDollars {
    return _valueInDollars;
}


-(NSString *)description {
    NSString *des = [NSString stringWithFormat:@"%@ (%@): Worth $%d , recorded on %@",_itemName,_serialNumber,_valueInDollars,_dateCreated];
    return des;
}

@end
