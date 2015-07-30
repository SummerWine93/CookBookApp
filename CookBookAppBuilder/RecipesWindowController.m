//
//  RecipesWindowController.m
//  CookBookApp
//
//  Created by User on 7/30/15.
//  Copyright (c) 2015 User. All rights reserved.
//

#import "RecipesWindowController.h"
#import "AppDelegate.h"
#include "Recipe.h"
#import "RecipeTableViewController.h"

@interface RecipesWindowController ()

@end

@implementation RecipesWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    AppDelegate *delegate = [[NSApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    
    RecipeTableViewController *recipeTVC = (RecipeTableViewController *)self.self.contentViewController;
    recipeTVC.managedObjectContext = self.managedObjectContext;
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
