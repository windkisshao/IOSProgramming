//
//  AppDelegate.m
//  Hypnosister
//
//  Created by ChenHao on 15/9/9.
//  Copyright (c) 2015年 ChenHao. All rights reserved.
//

#import "AppDelegate.h"
#import "BNRHypnosisView.h"

@interface AppDelegate ()<UIScrollViewDelegate>

@property(nonatomic,strong)BNRHypnosisView *hypnosisView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
//    CGRect firstFrame = CGRectMake(160, 240, 100, 150);
    CGRect firstFrame  = self.window.bounds;
    
    CGRect screenRect = self.window.bounds;
    
    CGRect bigRect = screenRect;
    
    bigRect.size.width *= 2.0;
    
//    bigRect.size.height *= 2.0;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    
    scrollView.delegate = self;
    
    [self.window addSubview:scrollView];
    
    //创建一个有着超大尺寸的BNRHy..view并将其加入UIScrollView
    
    _hypnosisView = [[BNRHypnosisView alloc] initWithFrame:screenRect];
    [scrollView addSubview:_hypnosisView];
    
    //告诉UIScrollView对象“取景”范围有多大
    scrollView.contentSize = bigRect.size ;
    
    scrollView.minimumZoomScale = 0.5;
    
    scrollView.maximumZoomScale = 2.0;
    
    firstFrame.origin.x += firstFrame.size.width;
    BNRHypnosisView *firstView = [[BNRHypnosisView alloc] initWithFrame:firstFrame];
    [scrollView addSubview:firstView];
    scrollView.pagingEnabled = NO; //此属性表示保持每次完整显示一个对象
    
    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window addSubview:firstView];

    [self.window makeKeyAndVisible];
    
    return YES;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _hypnosisView;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
