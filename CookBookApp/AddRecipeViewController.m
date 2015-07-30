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
        //[self.recipeIngredients layoutIfNeeded];
        //self.recipeIngredients.layoutManager.allowsNonContiguousLayout = false;
        //[self.recipeIngredients sizeToFit];
    }
    
    //CGSize newSize = CGSizeMake(self.recipeIngredients.frame.size.width, self.view.frame.size.height * 0.15);
    //self.recipeIngredients.frame.size = newSize;
    //self.recipeIngredientsHeight.constant = newSize.height;
    //self.recipeStepsHeight.constant = newSize.height;
    
    [super viewDidLoad];    
}

- (IBAction)chooseRecipeImage:(id)sender {
    [super changeRecipeImage:sender];
}

- (IBAction)addNewRecipe:(id)sender {
    [super insertNewObject:sender];
}

- (IBAction)chooseTypeOfDish:(id)sender {
    //self.typePickerView.hidden = !self.typePickerView.isHidden;
    self.typePickerView.hidden = YES;
}

@end
