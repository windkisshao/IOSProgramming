//
//  BNRItemStore.h
//  Homepwner
//
//  Created by ChenHao on 15/9/22.
//  Copyright (c) 2015年 ChenHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem;

@interface BNRItemStore : NSObject

@property(nonatomic,readonly)NSArray *allItems;

-(BNRItem *)createItem;

+(instancetype)sharedStore;

-(void)removeItem:(BNRItem *)item;

-(void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

@end
