//
//  ImageZoomView.m
//  CookBookApp
//
//  Created by User on 8/12/15.
//  Copyright (c) 2015 User. All rights reserved.
//

#import "ImageZoomView.h"

@implementation ImageZoomView

-(id)initWithFrame:(CGRect)frame andImage: (UIImage *)image{
    //UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(super.frame.origin.x, super.frame.origin.y, super.frame.size.width, super.frame.size.height)];
    UIView *backgroundView = [[UIView alloc] initWithFrame:frame];
    [backgroundView setBackgroundColor:[UIColor blackColor]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setImage:image];
    [backgroundView addSubview:imageView];
    
    return backgroundView;
}

@end
