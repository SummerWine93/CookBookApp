//
//  FavouriteRecipesViewController.m
//  CookBook v1
//
//  Created by User on 6/19/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import "FavouriteRecipesTableViewController.h"

@implementation FavouriteRecipesTableViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated{
    NSPredicate *favouritePredicate = [NSPredicate predicateWithFormat:@"isFavourite == %@", [NSNumber numberWithBool:YES]];
    [[self.fetchedResultsController fetchRequest] setPredicate:favouritePredicate];
    [NSFetchedResultsController deleteCacheWithName:@"Master"];
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
    
    favouritePredicate = nil;
    [super viewWillAppear:animated];
}

@end
