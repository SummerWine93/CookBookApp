//
//  CategoriesTableViewController.m
//  CookBook v1
//
//  Created by User on 7/23/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import "CategoriesTableViewController.h"

@interface CategoriesTableViewController ()

@end


@implementation CategoriesTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize categoryFetchResultsController = _categoryFetchResultsController;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    sharedDelegate = [AppDelegate appDelegate];
    self.managedObjectContext = [sharedDelegate managedObjectContext];
    
    self.categoryFetchResultsController = [sharedDelegate categoryFetchedResultsController];
    self.categoryFetchResultsController.delegate = self;
    
    [[self categoryFetchResultsController] performFetch:nil];
    [self.tableView reloadData];
}


-(void)viewWillAppear:(BOOL)animated{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)updateTableView: (UITableView *) tableView {
    [tableView beginUpdates];
    
    [tableView reloadData];
    [self.view setNeedsDisplay];
    [tableView endUpdates];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.categoryFetchResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id sectionInfo = [[self.categoryFetchResultsController sections] objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoriesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    RecipeCategory *category = [[self.categoryFetchResultsController fetchedObjects] objectAtIndex:indexPath.row];
    
    cell.label.text = category.name;
    NSString *imageName = [NSString stringWithFormat:@"%@.png", category.name];
    cell.image.image = [UIImage imageNamed:imageName];    
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    AllRecipesTableViewController *vc = [segue destinationViewController];
    vc.categoryPredicateData = [[[self.categoryFetchResultsController fetchedObjects] objectAtIndex:path.row] name];
}


@end
