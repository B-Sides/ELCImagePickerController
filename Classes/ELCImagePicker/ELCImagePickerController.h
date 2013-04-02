//
//  ELCImagePickerController.h
//  ELCImagePickerDemo
//
//  Created by ELC on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCAssetSelectionDelegate.h"

@class ELCImagePickerController;

@protocol ELCImagePickerControllerDelegate <UINavigationControllerDelegate>

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info;
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker;

@end

@interface ELCImagePickerController : UINavigationController <ELCAssetSelectionDelegate>

@property (nonatomic, assign) id<ELCImagePickerControllerDelegate> delegate;

- (void)cancelImagePicker;

@end

