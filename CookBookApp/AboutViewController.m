//
//  AboutViewController.m
//  CookBookApp
//
//  Created by User on 8/6/15.
//  Copyright (c) 2015 User. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController (){
    NSArray *cellText;
}

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.view.frame.size.width < 500) {
        if (self.view.frame.size.width < 340){
        self.names.font = [self.names.font fontWithSize:11];
        }
        else{
        self.names.font = [self.names.font fontWithSize:13];
        }
    }
    cellText = [NSArray arrayWithObjects:@"Hello! This is the CookBook app. It containes some great recipes from the Internet.", @"You can add your own recipes to your cook book. Just choose the recipe category and click the '+' button.", @"Besides that you are free to edit all the recipes in your cook book. Just ckick edit button and change whatever you need.", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (self.view.frame.size.width < 500) {
        if (self.view.frame.size.width < 340){
            cell.textLabel.font = [self.names.font fontWithSize:12];
        }
        else{
            cell.textLabel.font = [self.names.font fontWithSize:14];
        }
    }
    if ((indexPath.row < 3)) {
        cell.textLabel.numberOfLines = 6;
        cell.textLabel.text = [cellText objectAtIndex:indexPath.row];
        cell.userInteractionEnabled = NO;
    }
    return cell;
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
