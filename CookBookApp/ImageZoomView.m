//
//  ImageZoomView.m
//  CookBookApp
//
//  Created by User on 8/12/15.
//  Copyright (c) 2015 User. All rights reserved.
//

#import "ImageZoomView.h"
#import "ImageProcessor.h"

@implementation ImageZoomView

-(id)initWithFrame:(CGRect)frame andImage: (UIImage *)image{
    //UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(super.frame.origin.x, super.frame.origin.y, super.frame.size.width, super.frame.size.height)];
    UIView *backgroundView = [[UIView alloc] initWithFrame:frame];
    //UIView *backgroundView = [[UIView alloc] init];
    [backgroundView setBackgroundColor:[UIColor blackColor]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setImage:[ImageProcessor createFullScreenImageFromImage:image inFrame:frame]];
    [backgroundView addSubview:imageView];
    UITapGestureRecognizer *tapRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeZoomedView)];
    tapRecogniser.numberOfTapsRequired = 1;
    tapRecogniser.numberOfTouchesRequired = 1;
    tapRecogniser.delegate = self;
    [self addGestureRecognizer:tapRecogniser];
    [self becomeFirstResponder];
    
    return backgroundView;
}


-(void)closeZoomedView{
    NSLog(@"Close zoomed view");
    
    self.hidden = YES;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}




@end
