//
//  Asset.h
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class ELCAsset;

@protocol ELCAssetDelegate <NSObject>

@optional
- (void)assetSelected:(ELCAsset *)asset;

@end

@interface ELCAsset : UIView {
	ALAsset *asset;
	UIImageView *overlayView;
	id <ELCAssetDelegate> parent;
}

@property (nonatomic, retain) ALAsset *asset;
@property (nonatomic, assign) id parent;
@property (nonatomic, assign) BOOL selected;

-(id)initWithAsset:(ALAsset*)_asset;

@end