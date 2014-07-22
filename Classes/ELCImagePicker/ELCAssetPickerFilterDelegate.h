//
// ELCAssetPickerFilterDelegate.h

@class ELCAsset;
@class ELCAssetTablePicker;

@protocol ELCAssetPickerFilterDelegate<NSObject>

// respond YES/NO to filter out (not show the asset)
-(BOOL)assetTablePicker:(ELCAssetTablePicker *)picker isAssetFilteredOut:(ELCAsset *)elcAsset;

@end