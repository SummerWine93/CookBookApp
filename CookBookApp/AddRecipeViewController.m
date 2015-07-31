//
//  AddRecipeViewController.m
//  CookBook v1
//
//  Created by User on 6/19/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import "AddRecipeViewController.h"

@implementation AddRecipeViewController 

-(void)viewDidLoad{
    AppDelegate *sharedDelegate = [AppDelegate appDelegate];
    self.categoryFetchedResultsController = [sharedDelegate categoryFetchedResultsController];
    self.categoryFetchedResultsController.delegate = self;
    
    self.recipeName.text = self.nameId;
    NSArray *categories = [NSArray new];
    categories = [self.categoryFetchedResultsController fetchedObjects];
    
    for (RecipeCategory *category in [self.categoryFetchedResultsController fetchedObjects]){
        if ([category.name isEqualToString: self.categoryName]) {
            [self.typeOfDish setTitle:category.name forState:UIControlStateNormal];
        }
    }
    [super viewDidLoad];    
}

- (IBAction)chooseRecipeImage:(id)sender {
    [super changeRecipeImage:sender];
}

- (IBAction)addNewRecipe:(id)sender {
    [super insertNewObject:sender];
}

- (IBAction)chooseTypeOfDish:(id)sender {    
    self.typePickerView.hidden = YES;
}

@end
