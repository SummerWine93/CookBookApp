//
//  AboutViewController.h
//  CookBookApp
//
//  Created by User on 8/6/15.
//  Copyright (c) 2015 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *names;
@property (weak, nonatomic) IBOutlet UITableView *mainTextTable;

@end
