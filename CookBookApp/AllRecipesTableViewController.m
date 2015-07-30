//
//  AllRecipesTableViewController.m
//  CookBook v1
//
//  Created by User on 6/30/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import "AllRecipesTableViewController.h"

@interface AllRecipesTableViewController ()

@end

@implementation AllRecipesTableViewController

@synthesize categoryPredicateData = _categoryPredicateData;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

-(void)viewDidAppear:(BOOL)animated{    
    
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    NSPredicate *favouritePredicate = [NSPredicate predicateWithFormat:@"isFavourite != nil"];
    [[self.fetchedResultsController fetchRequest] setPredicate:favouritePredicate];
    NSPredicate *categoryPredicate = [NSPredicate predicateWithFormat:@"category.name == %@", self.categoryPredicateData];
    [[self.fetchedResultsController fetchRequest] setPredicate:categoryPredicate];
    [NSFetchedResultsController deleteCacheWithName:@"Master"];
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
    
    favouritePredicate = nil;
    categoryPredicate = nil;
    [self.view setNeedsDisplay];
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
}

-(IBAction)unvindToAllRecipes:(UIStoryboardSegue*)unwindSegue{
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    Recipe *recipe = [self.fetchedResultsController objectAtIndexPath:path];
    
    if([segue.identifier isEqualToString:@"addNewRecipe"]){
        AddRecipeViewController *vc = [segue destinationViewController];
        vc.categoryName = self.categoryPredicateData;
    }
    
    RecipeViewController *vc = [segue destinationViewController];
    vc.delegate = self;
    path = nil;
    vc = nil;
    recipe = nil;
    
    [super prepareForSegue:segue sender:sender];
}

#pragma mark - Table view data source



@end