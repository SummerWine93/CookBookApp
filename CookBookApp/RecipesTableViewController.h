//
//  RecipesTableViewController.h
//  CookBook v1
//
//  Created by User on 6/22/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RecipeViewController.h"
#import "ShowRecipeViewController.h"
#include "SimpleTableViewCell.h"
#import "AddRecipeViewController.h"

@interface RecipesTableViewController : UITableViewController <NSCopying, NSFetchedResultsControllerDelegate, RecipeChangedDelegate, NSFetchedResultsControllerDelegate>{
    AppDelegate *sharedDelegate;    
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *categoryFetchResultsController;
@property (strong, nonatomic) NSArray *categoryFetchResults;

@end
