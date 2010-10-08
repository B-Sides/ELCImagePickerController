//
//  ELCImagePickerController.m
//  ELCImagePickerDemo
//
//  Created by Collin Ruffenach on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import "ELCImagePickerController.h"

@implementation ELCImagePickerController

@synthesize delegate;

-(id)initImagePicker {

	if(self = [super init]) {
		AlbumPickerController *albumController = [[AlbumPickerController alloc] initWithNibName:@"AlbumPickerController" bundle:[NSBundle mainBundle]];
		[albumController setParent:self];
		
		[super initWithRootViewController:albumController];
		[albumController release];
	}
	
	return self;
}

-(void)cancelImagePicker {
	
	if([delegate respondsToSelector:@selector(elcImagePickerControllerDidCancel:)]) {
		[delegate performSelector:@selector(elcImagePickerControllerDidCancel:) withObject:self];
	}
}

-(void)selectedAssets:(NSArray*)_assets {

	NSMutableArray *returnArray = [[NSMutableArray alloc] init];
	
	for(ALAsset *asset in _assets) {

		NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
		[workingDictionary setObject:[asset valueForProperty:ALAssetPropertyType] forKey:@"UIImagePickerControllerMediaType"];
		[workingDictionary setObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]] forKey:@"UIImagePickerControllerOriginalImage"];
		[workingDictionary setObject:[[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] forKey:@"UIImagePickerControllerReferenceURL"];
		
		[returnArray addObject:workingDictionary];
		
		[workingDictionary release];	
	}
	
	if([delegate respondsToSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:)]) {
		[delegate performSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:) withObject:self withObject:[NSArray arrayWithArray:returnArray]];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}

@end

@implementation AlbumPickerController

@synthesize parent;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.navigationItem setTitle:@"Loading..."];
	
	queue = [NSOperationQueue mainQueue];
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(preparePhotos) object:nil];
	[queue addOperation:operation];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss:)];
	[self.navigationItem setRightBarButtonItem:cancelButton];
	[cancelButton release];
}

-(void)dismiss:(id)sender {

	[parent cancelImagePicker];
}

-(void)preparePhotos {
	
	void (^assetGroupEnumerator)(struct ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
		if(group != nil) {
			[assetGroups addObject:group];
			NSLog(@"Number of assets in group %d", [group numberOfAssets]);
		}
		
		[self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
	};
	
	assetGroups = [[NSMutableArray alloc] init];
	
	ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
	[library enumerateGroupsWithTypes:ALAssetsGroupAll
						   usingBlock:assetGroupEnumerator 
						 failureBlock:^(NSError *error) {
							 NSLog(@"A problem occured");					
						 }];	
	[library release];
}

-(void)reloadTableView {
	
	[self.tableView reloadData];
	[self.navigationItem setTitle:@"Select an Album"];
}

-(void)selectedAssets:(NSArray*)_assets {
	
	[(ELCImagePickerController*)parent selectedAssets:_assets];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [assetGroups count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)",[(ALAsset*)[assetGroups objectAtIndex:indexPath.row] valueForProperty:ALAssetsGroupPropertyName], [(ALAssetsGroup*)[assetGroups objectAtIndex:indexPath.row] numberOfAssets]];
    [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[assetGroups objectAtIndex:indexPath.row] posterImage]]];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	AssetTablePicker *picker = [[AssetTablePicker alloc] initWithNibName:@"AssetTablePicker" bundle:[NSBundle mainBundle]];
	[picker setParent:self];
	[picker setAssetsGroup:[assetGroups objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:picker animated:YES];
	[picker release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 57;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	
	[assetGroups release];
    [super dealloc];
}

@end

@implementation AssetTablePicker

@synthesize parent;
@synthesize selectedAssetsLabel;

-(void)viewDidLoad {

	[self.tableView setSeparatorColor:[UIColor clearColor]];
	[self.tableView setAllowsSelection:NO];
	
	UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss:)];
	[self.navigationItem setRightBarButtonItem:doneButtonItem];
	[self.navigationItem setTitle:@"Loading..."];
	
	[self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
}

- (void)setAssetsGroup:(ALAssetsGroup*)_group {
	
	assetGroup = _group;
}

-(void)preparePhotos {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	void (^assetEnumerator)(struct ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
		
		if(result != nil) {
			
			if(![assetURLDictionaries containsObject:[result valueForProperty:ALAssetPropertyURLs]]) {
				if(![[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
					[assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
					Asset *asset = [[Asset alloc] initWithAsset:result];
					[assets addObject:asset];
				}
			}
		}
	};
	
	assets = [[NSMutableArray alloc] init];
	assetURLDictionaries = [[NSMutableArray alloc] init];
	
	[assetGroup enumerateAssetsUsingBlock:assetEnumerator];
	
	[self.tableView reloadData];
	[self.navigationItem setTitle:@"Pick Photos"];
	
	[pool release];
}

-(IBAction)dismiss:(id)sender {
	
	NSMutableArray *selectedAssetsImages = [[NSMutableArray alloc] init];
	
	for(Asset *asset in assets) {
		
		if([asset selected]) {
			
			[selectedAssetsImages addObject:[asset asset]];
		}
	}
	
	[(AlbumPickerController*)parent selectedAssets:[NSArray arrayWithArray:selectedAssetsImages]];
}

-(NSArray*)assetsForIndexPath:(NSIndexPath*)_indexPath {
	
	int index = (_indexPath.row*4);
	int maxIndex = (_indexPath.row*4+3);
	
	NSLog(@"Getting assets for %d to %d with array count %d", index, maxIndex, [assets count]);
	
	if(maxIndex < [assets count]) {
	
		return [NSArray arrayWithObjects:[assets objectAtIndex:index],
				[assets objectAtIndex:index+1],
				[assets objectAtIndex:index+2],
				[assets objectAtIndex:index+3],
				nil];
	}
	
	else if(maxIndex-1 < [assets count]) {
		
		return [NSArray arrayWithObjects:[assets objectAtIndex:index],
				[assets objectAtIndex:index+1],
				[assets objectAtIndex:index+2],
				nil];
	}
	
	else if(maxIndex-2 < [assets count]) {
		
		return [NSArray arrayWithObjects:[assets objectAtIndex:index],
				[assets objectAtIndex:index+1],
				nil];
	}
	
	else if(maxIndex-3 < [assets count]) {
		
		return [NSArray arrayWithObject:[assets objectAtIndex:index]];
	}
	
	return nil;
}

#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return ceil([assets count]/4.0);
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    AssetCell *cell = (AssetCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		
        cell = [[[AssetCell alloc] initWithAssets:[self assetsForIndexPath:indexPath] reuseIdentifier:CellIdentifier] autorelease];
    }
	
	else {
		
		[cell setAssets:[self assetsForIndexPath:indexPath]];
	}
    	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

	return 79;
}

- (void)dealloc {
	
    [super dealloc];
}

@end

@implementation AssetCell

-(id)initWithAssets:(NSArray*)_assets reuseIdentifier:(NSString*)_identifier {

	if(self = [super initWithStyle:UITableViewStylePlain reuseIdentifier:_identifier]) {
	
		assets = _assets;
		[assets retain];
	}
	
	return self;
}

-(void)setAssets:(NSArray*)_assets {
	
	for(UIView *view in [self subviews]) {
		
		[view removeFromSuperview];
	}
	
	assets = nil;
	assets = _assets;
	[assets retain];
}

-(void)layoutSubviews {

	CGRect frame = CGRectMake(4, 2, 75, 75);
	
	for(Asset *asset in assets) {
		
		[asset setFrame:frame];
		[asset addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:asset action:@selector(toggleSelection)]];
		[self addSubview:asset];
		
		frame.origin.x = frame.origin.x + frame.size.width + 4;
		[asset release];
	}
}

-(void)dealloc {

	[assets release];
	[super dealloc];
}

@end

@implementation Asset

@synthesize asset;
@synthesize parent;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

-(id)initWithAsset:(ALAsset*)_asset {
	
	if (self = [super initWithFrame:CGRectMake(0, 0, 0, 0)]) {
		
		asset = _asset;
		[asset retain];
		
		CGRect viewFrames = CGRectMake(0, 0, 75, 75);
		
		UIImageView *assetImageView = [[UIImageView alloc] initWithFrame:viewFrames];
		[assetImageView setContentMode:UIViewContentModeScaleToFill];
		[assetImageView setImage:[UIImage imageWithCGImage:[asset thumbnail]]];
		
		[self addSubview:assetImageView];
		[assetImageView release];
		
		overlayView = [[UIImageView alloc] initWithFrame:viewFrames];
		[overlayView setImage:[UIImage imageNamed:@"Overlay.png"]];
		[overlayView setHidden:YES];
		[self addSubview:overlayView];
    }
    
	return self;	
}

-(void)toggleSelection {
	
	overlayView.hidden = !overlayView.hidden;
}

-(BOOL)selected {
	
	return !overlayView.hidden;
}

-(void)setSelected:(BOOL)_selected {

	[overlayView setHidden:!_selected];
}

- (void)dealloc {

	[asset release];
	[overlayView release];
    [super dealloc];
}

@end
