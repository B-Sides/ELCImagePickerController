//
//  EYLargePhotoManager.h
//  ELCImagePickerDemo
//
//  Created by ericyang on 14-4-24.
//  Copyright (c) 2014年 ELC Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EYLargePhoto.h"

@interface EYLargePhotoManager : NSObject
+(EYLargePhotoManager*)share;
-(NSData*)getOriginalData:(EYLargePhoto*)photo;
-(EYLargePhoto*)saveOriginalImage:(UIImage*)originalImg;
-(void)deleteImage:(EYLargePhoto*)photo;
@end
