//
//  EYLargePhotoManager.m
//  ELCImagePickerDemo
//
//  Created by ericyang on 14-4-24.
//  Copyright (c) 2014年 ELC Technologies. All rights reserved.
//

#import "EYLargePhotoManager.h"
#import "UIImage+EYFixOrientation.h"

@implementation EYLargePhotoManager
+(EYLargePhotoManager*)share{
    static EYLargePhotoManager* instance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=[[EYLargePhotoManager alloc]init];
        NSString* path=[instance getTmpPath];
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        
        NSDirectoryEnumerator* en = [fm enumeratorAtPath:path];
        NSError* err = nil;
        NSString* file;
        while (file = [en nextObject]) {
            if (![fm removeItemAtPath:[path stringByAppendingPathComponent:file] error:&err]
                && err) {
                NSLog(@"oops: %@", err);
            }
        }
    });
    return instance;
}

-(NSString*)getTmpPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* customPath = [paths[0] stringByAppendingPathComponent:@"com.appcpu.EYLargePhoto"];
    return customPath;
}
-(NSString*)getOriginalFilePath:(EYLargePhoto*)photo{
    NSString* localPath=[self getTmpPath];
    NSString* fileName=[NSString stringWithFormat:@"%@",photo];
    return [localPath stringByAppendingPathComponent:fileName];
}

-(UIImage*)getSqareThumb:(UIImage*)img width:(float)width{
    CGSize size=img.size;
    CGRect newFr;
    float minWdith=MIN(size.width,size.height);
    float maxWdith=MAX(size.width,size.height);
    if (size.width<size.height) {
        newFr=CGRectMake(0, (maxWdith-minWdith)/2, minWdith, minWdith);
    } else {
        newFr=CGRectMake((maxWdith-minWdith)/2, 0, minWdith, minWdith);
    }
    CGImageRef cr = CGImageCreateWithImageInRect([img CGImage], newFr);
    UIImage *cropped = [UIImage imageWithCGImage:cr];
    CGImageRelease(cr);
    return [UIImage imageWithData:UIImageJPEGRepresentation(cropped, 0.05)];
}
-(EYLargePhoto*)saveOriginalImage:(UIImage*)originalImg{
    EYLargePhoto* photo=[[EYLargePhoto alloc]init];
    @autoreleasepool {
        originalImg=[originalImg fixOrientation];
        UIImage* newImg=[UIImage imageWithCGImage:[originalImg CGImage] scale:1 orientation:originalImg.imageOrientation];
        NSData* data= UIImageJPEGRepresentation(newImg, 0.9);
        
        //save original file
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm createFileAtPath:[self getOriginalFilePath:photo] contents:data attributes:nil];
        
        //create thumb
        photo.thumb=[self getSqareThumb:newImg width:100];
    }
    return photo;
}
-(NSData*)getOriginalData:(EYLargePhoto*)photo{
    return [NSData dataWithContentsOfFile:[self getOriginalFilePath:photo]];
}
-(void)deleteImage:(EYLargePhoto*)photo{
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:[NSString stringWithFormat:@"%@",photo] error:0];
}



@end
