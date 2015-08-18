
//
//  ImageProcessor.m
//  CookBook v1
//
//  Created by User on 7/20/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import "ImageProcessor.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "PathManager.h"

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
        newSize = CGSizeMake(320, 240);
    }
    
    if (!CGSizeEqualToSize(newSize, oldSize)) {
        CGFloat widthFactor = newSize.width/oldSize.width;
        CGFloat heightFactor = newSize.height/oldSize.height;
        
        //if (((widthFactor > heightFactor)||(heightFactor > 1))&&(widthFactor < 1)) {
        if ((widthFactor > heightFactor)) {
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
    
    UIImage *newImage = nil;
    newImage = [self drawImage:image InContextWithSize:newSize];
    [UIImagePNGRepresentation(newImage) writeToFile:path atomically:YES];
    
    return newImage;
}

+(UIImage *)drawImage: (UIImage *)image InContextWithSize: (CGSize) newSize {
    UIImage *newImage;
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage *) createFullScreenImageFromImage: (UIImage *) image inFrame: (CGRect)frame{
    CGSize oldSize = image.size;
    CGSize newSize = frame.size;
   
    CGFloat scaleFactor;
    
    if (!CGSizeEqualToSize(newSize, oldSize)) {
        CGFloat widthFactor = newSize.width/oldSize.width;
        CGFloat heightFactor = newSize.height/oldSize.height;
        
        if ((widthFactor > heightFactor)) {
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        newSize.width = scaleFactor*oldSize.width;
        newSize.height = scaleFactor*oldSize.height;
}
    
    UIImage *newImage = [self drawImage:image InContextWithSize:newSize];
    return newImage;
}



@end
