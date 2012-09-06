//
//  AlbumPickerController.h
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ELCAssetSelectionDelegate.h"

@interface ELCAlbumPickerController : UITableViewController <ELCAssetSelectionDelegate> {
	
	NSMutableArray *assetGroups;
	NSOperationQueue *queue;
	id <ELCAssetSelectionDelegate> parent;
    
    ALAssetsLibrary *library;
}

@property (nonatomic, assign) id parent;
@property (nonatomic, retain) NSMutableArray *assetGroups;

@end

