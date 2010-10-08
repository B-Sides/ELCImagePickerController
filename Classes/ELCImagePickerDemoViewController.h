//
//  ELCImagePickerDemoViewController.h
//  ELCImagePickerDemo
//
//  Created by Collin Ruffenach on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerController.h"

@interface ELCImagePickerDemoViewController : UIViewController <ELCImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate> {

	IBOutlet UIScrollView *scrollview;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollview;

-(IBAction)launchController;

@end

