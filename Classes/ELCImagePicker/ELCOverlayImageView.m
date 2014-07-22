//
//  ELCOverlayImageView.m
//  ELCImagePickerDemo
//
//  Created by Seamus on 14-7-11.
//  Copyright (c) 2014年 ELC Technologies. All rights reserved.
//

#import "ELCOverlayImageView.h"
#import "ELCConsole.h"
@implementation ELCOverlayImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setIndex:(int)_index
{
    labIndex.text = [NSString stringWithFormat:@"%d",_index];
}

- (void)dealloc
{
    labIndex = nil;
}

- (id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        UIImageView *img = [[UIImageView alloc] initWithImage:image];
        [self addSubview:img];
        
        if ([[ELCConsole mainConsole] onOrder]) {
            labIndex = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 16, 16)];
            labIndex.backgroundColor = [UIColor redColor];
            labIndex.clipsToBounds = YES;
            labIndex.textAlignment = NSTextAlignmentCenter;
            labIndex.textColor = [UIColor whiteColor];
            labIndex.layer.cornerRadius = 8;
            labIndex.layer.shouldRasterize = YES;
            //        labIndex.layer.borderWidth = 1;
            //        labIndex.layer.borderColor = [UIColor greenColor].CGColor;
            labIndex.font = [UIFont boldSystemFontOfSize:13];
            [self addSubview:labIndex];
        }
    }
    return self;
}




@end
