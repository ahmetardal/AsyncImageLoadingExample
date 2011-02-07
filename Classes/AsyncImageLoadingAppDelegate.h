//
//  AsyncImageLoadingAppDelegate.h
//  AsyncImageLoading
//
//  Created by Ahmet Ardal on 2/7/11.
//  Copyright 2011 LiveGO. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AsyncImageLoadingViewController;

@interface AsyncImageLoadingAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AsyncImageLoadingViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AsyncImageLoadingViewController *viewController;

@end

