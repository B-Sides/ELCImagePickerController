//
//  ELCImagePickerDemoViewController.m
//  ELCImagePickerDemo
//
//  Created by Collin Ruffenach on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import "ELCImagePickerDemoViewController.h"

@implementation ELCImagePickerDemoViewController

@synthesize scrollview;

-(IBAction)launchController {
	
	ELCImagePickerController *controller = [[ELCImagePickerController alloc] initImagePicker];
	[controller setDelegate:self];
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
	
	[self dismissModalViewControllerAnimated:YES];
	
	CGRect workingFrame = scrollview.frame;
	workingFrame.origin.x = 0;
	
	for(NSDictionary *dict in info) {
	
		UIImageView *imageview = [[UIImageView alloc] initWithImage:[dict objectForKey:UIImagePickerControllerOriginalImage]];
		[imageview setContentMode:UIViewContentModeScaleAspectFit];
		imageview.frame = workingFrame;
		
		[scrollview addSubview:imageview];
		[imageview release];
		
		workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
	}
	
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
