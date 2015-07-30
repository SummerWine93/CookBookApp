//
//  AddRecipeViewController.h
//  CookBook v1
//
//  Created by User on 6/19/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeViewController.h"



@interface AddRecipeViewController : RecipeViewController <UITableViewDataSource, UITableViewDelegate>

@property NSString *categoryName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recipeIngredientsHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recipeStepsHeight;

- (IBAction)chooseRecipeImage:(id)sender;
- (IBAction)addNewRecipe:(id)sender;
- (IBAction)chooseTypeOfDish:(id)sender;

@end
