//
//  ImageProcessor.h
//  CookBook v1
//
//  Created by User on 7/20/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

@interface ImageProcessor : NSObject

+(UIImage *) createImageFromImage: (UIImage*)image WithName: (NSString *)name Thumbnail: (BOOL)isThumbnail;
+(UIImage *)drawImage: (UIImage *)image InContextWithSize: (CGSize) newSize;
+(UIImage *) createFullScreenImageFromImage: (UIImage *) image inFrame: (CGRect)frame;
+(UIImage *) createThumbnailImageFromImage: (UIImage *) image;

@end
