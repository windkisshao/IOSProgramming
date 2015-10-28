//
//  BNRItemStore.m
//  Homepwner
//
//  Created by ChenHao on 15/9/22.
//  Copyright (c) 2015年 ChenHao. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@interface BNRItemStore()

@property(nonatomic)NSMutableArray *privateItems;

@end

@implementation BNRItemStore

+(instancetype)sharedStore {
    static BNRItemStore *sharedStore = nil;
    
    //判断是否需要创建一个sharedStore对象
    
    if (!sharedStore) {
        sharedStore = [[BNRItemStore alloc] initPrivate];
    }
    
    return sharedStore;
}

//如果调用[[BNRItemStore alloc] init],就提示应该使用[BNRItemStore sharedStore]

-(instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use + [BNRItemStore sharedStore]" userInfo:nil];
    return nil;
}

//这里真正的初始化方法
-(instancetype)initPrivate {
    self = [super init];
    if (self) {
        _privateItems = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSArray *)allItems {
    return [self.privateItems copy]; //使用copy返回不可变的副本
}

-(BNRItem *)createItem {
    BNRItem *item = [BNRItem randomItem];
    
    [self.privateItems addObject:item];
    
    return item;
}

-(void)removeItem:(BNRItem *)item {
    [[BNRImageStore sharedStore] deleteImageForKey:item.itemKey];
    [self.privateItems removeObjectIdenticalTo:item];
}

-(void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (fromIndex == toIndex) {
        return;
    }
    //得到要移动的对象的指针，以便稍后能将其插入新的位置
    BNRItem *item = self.privateItems[fromIndex];
    
    //将Item从allItems 数组中移除
    [self.privateItems removeObjectAtIndex:fromIndex];
    
    //根据新的索引位置，将Item插回allItems数组
    [self.privateItems insertObject:item atIndex:toIndex];
}



@end
