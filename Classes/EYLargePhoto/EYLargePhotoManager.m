//
//  EYLargePhotoManager.m
//  ELCImagePickerDemo
//
//  Created by ericyang on 14-4-24.
//  Copyright (c) 2014年 ELC Technologies. All rights reserved.
//

#import "EYLargePhotoManager.h"

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
            NSLog(@"file:%@",file);
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
#ifdef DEBUG
    NSString* fileName=[NSString stringWithFormat:@"%@.png",photo];
//    NSLog(@"model....Debug");
#else
    NSString* fileName=[NSString stringWithFormat:@"%@",photo];
//    NSLog(@"model....Release");
#endif
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
    
    return [UIImage imageWithData:UIImageJPEGRepresentation(cropped, 1/10)];
}
-(EYLargePhoto*)saveOriginalImage:(UIImage*)originalImg{
    
    
    EYLargePhoto* photo=[[EYLargePhoto alloc]init];
    @autoreleasepool {
        NSData* data= UIImageJPEGRepresentation(originalImg, 0.9);
        
        //save original file
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm createFileAtPath:[self getOriginalFilePath:photo] contents:data attributes:nil];
        
        //create thumb
        photo.thumb=[self getSqareThumb:originalImg width:100];
    }
    return photo;
}
-(NSData*)getOriginalData:(EYLargePhoto*)photo{
    return [NSData dataWithContentsOfFile:[self getOriginalFilePath:photo]];
}

@end
