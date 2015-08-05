//
//  FullSizeImageViewController.m
//  CookBookApp
//
//  Created by User on 8/5/15.
//  Copyright (c) 2015 User. All rights reserved.
//

#import "FullSizeImageViewController.h"

@interface FullSizeImageViewController ()

-(IBAction)handleSingleTap:(UIButton *)tapGestureRecogniser;

@end

@implementation FullSizeImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:self.imageName];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    //image = [UIImage imageNamed:@"defaultImage.jpg"];
    [self.imageView setImage:image];
    self.scrollView.delegate = self;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - UIScrollViewDelegate methods

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(IBAction)handleSingleTap:(UIButton *)tapGestureRecogniser {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
