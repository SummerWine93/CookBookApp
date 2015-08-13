//
//  ImageZoomView.h
//  CookBookApp
//
//  Created by User on 8/12/15.
//  Copyright (c) 2015 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageZoomView : UIView <UIGestureRecognizerDelegate>

-(id)initWithFrame:(CGRect)frame andImage: (UIImage *)image;

@end
