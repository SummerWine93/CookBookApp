//
//  ImageProcessor.m
//  CookBook v1
//
//  Created by User on 7/20/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import "ImageProcessor.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation ImageProcessor


+(UIImage *) createImageFromImage: (UIImage *)image WithName:(NSString *)name Thumbnail: (BOOL)isThumbnail{
    CGSize oldSize = image.size;
    CGSize newSize;
    CGFloat scaleFactor;
    if (isThumbnail) {
        name = [NSString stringWithFormat:@"t_%@", name];
        newSize = CGSizeMake(125, 92);
    }
    else{
        newSize = CGSizeMake(360, 214);
    }
    
    if (!CGSizeEqualToSize(newSize, oldSize)) {
        CGFloat widthFactor = newSize.width/oldSize.width;
        CGFloat heightFactor = newSize.height/oldSize.height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        
        newSize.width = scaleFactor*oldSize.width;
        newSize.height = scaleFactor*oldSize.height;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:name];
    
    UIImage *newImage = [self drawImage:image InContextWithSize:newSize];    
    [UIImagePNGRepresentation(newImage) writeToFile:path atomically:YES];
    
    return newImage;
}

+(UIImage *)drawImage: (UIImage *)image InContextWithSize: (CGSize) newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
