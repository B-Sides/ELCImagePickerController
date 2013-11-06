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
@class ELCAlbumPickerController;

@protocol ELCImagePickerControllerDelegate <UINavigationControllerDelegate>

/**
 * Called with the picker the images were selected from, as well as an array of dictionary's
 * containing keys for ALAssetPropertyLocation, ALAssetPropertyType, 
 * UIImagePickerControllerOriginalImage, and UIImagePickerControllerReferenceURL.
 * @param picker
 * @param info An NSArray containing dictionary's with the key UIImagePickerControllerOriginalImage, which is a rotated, and sized for the screen 'default representation' of the image selected. If you want to get the original image, use the UIImagePickerControllerReferenceURL key.
 */
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info;

/**
 * Called when image selection was cancelled, by tapping the 'Cancel' BarButtonItem.
 */
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker;

@end

@interface ELCImagePickerController : UINavigationController <ELCAssetSelectionDelegate>

@property (nonatomic, weak) id<ELCImagePickerControllerDelegate> imagePickerDelegate;
@property (nonatomic, assign) NSInteger maximumImagesCount;

- (void)cancelImagePicker;

@end

