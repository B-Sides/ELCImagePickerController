//
//  ELCImagePickerDemoViewController.m
//  ELCImagePickerDemo
//
//  Created by Collin Ruffenach on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import "ELCImagePickerDemoAppDelegate.h"
#import "ELCImagePickerDemoViewController.h"
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"
#import "ELCAssetTablePicker.h"

@implementation ELCImagePickerDemoViewController

@synthesize scrollview;
@synthesize chosenImages;

-(IBAction)launchController {
	
    ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName:@"ELCAlbumPickerController" bundle:[NSBundle mainBundle]];    
	ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
    [albumController setParent:elcPicker];
	[elcPicker setDelegate:self];
    
    ELCImagePickerDemoAppDelegate *app = (ELCImagePickerDemoAppDelegate *)[[UIApplication sharedApplication] delegate];
	[app.viewController presentModalViewController:elcPicker animated:YES];
    [elcPicker release];
    [albumController release];
}

- (IBAction)launchSpecialController {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    NSMutableArray *groups = [NSMutableArray array];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [groups addObject:group];
        } else {
            // this is the end
            [self displayPickerForGroup:[groups objectAtIndex:0]];
        }
    } failureBlock:^(NSError *error) {
        self.chosenImages = nil;
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        NSLog(@"A problem occured %@", [error description]);
        // an error here means that the asset groups were inaccessable.
        // Maybe the user or system preferences refused access.
    }];
}

- (void)displayPickerForGroup:(ALAssetsGroup *)group {
	ELCAssetTablePicker *tablePicker = [[ELCAssetTablePicker alloc] initWithNibName:@"ELCAssetTablePicker" bundle:[NSBundle mainBundle]];
    tablePicker.singleSelection = YES;
    tablePicker.immediateReturn = YES;
    tablePicker.startAtBottom = YES;
    
	ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:tablePicker];
    elcPicker.delegate = self;
	tablePicker.parent = elcPicker;
    
    // Move me
    tablePicker.assetGroup = group;
    [tablePicker.assetGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    
	[self presentModalViewController:elcPicker animated:YES];
	[tablePicker release];
    [elcPicker release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
	
	[self dismissModalViewControllerAnimated:YES];
	
    for (UIView *v in [scrollview subviews]) {
        [v removeFromSuperview];
    }
    
	CGRect workingFrame = scrollview.frame;
	workingFrame.origin.x = 0;
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
	
	for(NSDictionary *dict in info) {
	
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        [images addObject:image];
        
		UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
		[imageview setContentMode:UIViewContentModeScaleAspectFit];
		imageview.frame = workingFrame;
		
		[scrollview addSubview:imageview];
		[imageview release];
		
		workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
	}
    
    self.chosenImages = images;
	
	[scrollview setPagingEnabled:YES];
	[scrollview setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {

	[self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
