//
//  ELCOverlayImageView.h
//  ELCImagePickerDemo
//
//  Created by Seamus on 14-7-11.
//  Copyright (c) 2014年 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELCOverlayImageView : UIImageView
{
    __strong UILabel *labIndex;
}
- (void)setIndex:(int)_index;
@end
