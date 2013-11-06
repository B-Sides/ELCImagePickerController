//
//  ELCImagePickerDemoAppDelegate.h
//  ELCImagePickerDemo
//
//  Created by ELC on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ELCImagePickerDemoViewController;

@interface ELCImagePickerDemoAppDelegate : NSObject <UIApplicationDelegate> 

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet ELCImagePickerDemoViewController *viewController;

@end

