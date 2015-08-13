//
//  ShowRecipetViewController.h
//  CookBook v1
//
//  Created by User on 6/19/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeViewController.h"


@interface ShowRecipeViewController : RecipeViewController <UITextViewDelegate>{
    BOOL isEdited;
    NSManagedObjectContext *context;
    IBOutlet UITapGestureRecognizer *imagePickerGestureRecogniser;
}
@property (weak, nonatomic) IBOutlet UIView *editMenuView;
@property (weak, nonatomic) IBOutlet UIView *optionsMenuView;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recipeIngredientsHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recipeStepsHeight;
//@property (weak, nonatomic) IBOutlet UIScrollView *fullScreenImageScrollView;
@property (strong, nonatomic) UIImageView *iv;

- (IBAction)changeRecipeImage:(id)sender;
- (IBAction)editRecipe:(id)sender;
- (IBAction)addRecipeToFavourite:(id)sender;
- (IBAction)chooseTypeOfDish:(id)sender;
- (IBAction)deleteRecipe:(id)sender;
- (IBAction)saveChanges:(id)sender;
- (IBAction)cancelChanges:(id)sender;


@property id objectId;

@end
