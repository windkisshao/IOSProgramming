//
//  BNRImageStore.h
//  Homepwner
//
//  Created by ChenHao on 15/9/24.
//  Copyright (c) 2015年 ChenHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BNRImageStore : NSObject

+ (instancetype) sharedStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;

- (UIImage *) imageForKey: (NSString *)key;

- (void) deleteImageForKey: (NSString *)key;

@end
