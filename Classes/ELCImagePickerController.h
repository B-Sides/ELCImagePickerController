//
//  ELCImagePickerController.h
//  ELCImagePickerDemo
//
//  Created by Collin Ruffenach on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ELCImagePickerController : UINavigationController {

	id delegate;
}

@property (nonatomic, assign) id delegate;

-(void)selectedAssets:(NSArray*)_assets;
-(void)cancelImagePicker;
-(id)initImagePicker;

@end

@interface AlbumPickerController : UITableViewController {
	
	NSMutableArray *assetGroups;
	NSOperationQueue *queue;
	id parent;
}

@property (nonatomic, assign) id parent;

-(void)preparePhotos;
-(void)selectedAssets:(NSArray*)_assets;

@end

@interface AssetTablePicker : UITableViewController
{
	ALAssetsGroup *assetGroup;
	
	NSMutableArray *assets;
	NSMutableArray *assetURLDictionaries;
	int selectedAssets;
	
	id parent;
	
	NSOperationQueue *queue;
}

@property (nonatomic, retain) IBOutlet UILabel *selectedAssetsLabel;
@property (nonatomic, assign) id parent;

-(void)setAssetsGroup:(ALAssetsGroup*)_group;
-(IBAction)dismiss:(id)sender;

@end

@interface AssetCell : UITableViewCell
{
	NSArray *assets;
}

-(id)initWithAssets:(NSArray*)_assets reuseIdentifier:(NSString*)_identifier;
-(void)setAssets:(NSArray*)_assets;

@end

@interface Asset : UIView {
	ALAsset *asset;
	UIImageView *overlayView;
	BOOL selected;
	id parent;
}

@property (nonatomic, retain) ALAsset *asset;
@property (nonatomic, assign) id parent;

-(id)initWithAsset:(ALAsset*)_asset;
-(BOOL)selected;

@end

@protocol ELCImagePickerControllerDelegate

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info;
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker;

@end

