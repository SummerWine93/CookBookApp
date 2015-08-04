//
//  AboutTableViewController.m
//  CookBookApp
//
//  Created by User on 7/31/15.
//  Copyright (c) 2015 User. All rights reserved.
//

#import "AboutTableViewController.h"

@interface AboutTableViewController (){
    NSArray *cellText;
}

@end

@implementation AboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cellText = [NSArray arrayWithObjects:@"Hello! This is the CookBook app. It containes some great recipes from the Internet.", @"You can add your own recipes to your cook book. Just choose the recipe category and click the '+' button.", @"Besides that you are free to edit all the recipes in your cook book. Just ckick edit button and change whatever you need.", nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (self.view.window.frame.size.width <= 320) {
        cell.textLabel.numberOfLines = 4;
    }
    
    if (indexPath.row < 3) {
        cell.textLabel.text = [cellText objectAtIndex:indexPath.row];
    }
    else{
        UIImageView *imageView;
        if (self.view.window.frame.size.width >= 400) {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.window.frame.size.width * 1.5 / 2, self.view.window.frame.size.width * 3 / 6 )];
        }
        else{
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.window.frame.size.width, self.view.window.frame.size.width * 2 / 3 )];
        }
        CGPoint centerImageView = imageView.center;
        centerImageView.x = self.view.center.x;
        imageView.center = centerImageView;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"defaultImage.jpg"];
        [cell.contentView addSubview:imageView];
    }
    cell.userInteractionEnabled = NO;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        return 200;
    }
    return 100;
}

@end
