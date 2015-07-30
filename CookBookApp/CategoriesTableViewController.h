//
//  CategoriesTableViewController.h
//  CookBook v1
//
//  Created by User on 7/23/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CategoriesTableViewCell.h"
#import "RecipeCategory.h"
#import "AllRecipesTableViewController.h"

@interface CategoriesTableViewController : UITableViewController
    <NSCopying, NSFetchedResultsControllerDelegate, NSFetchedResultsControllerDelegate>
{
        AppDelegate *sharedDelegate;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *categoryFetchResultsController;
@property (strong, nonatomic) NSArray *categoryFetchResults;

@end
