//
//  ShowRecipetViewController.h
//  CookBook v1
//
//  Created by User on 6/19/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeViewController.h"
#include "ImageZoomView.h"

@class RecipesTableViewController;

@protocol RecipesTableUpdateDelegate <NSObject>
-(void)removeImageFromCache: (id) imageInCache;
@end


@interface ShowRecipeViewController : RecipeViewController <UITextViewDelegate>{
    BOOL isEdited;
    NSManagedObjectContext *context;
    IBOutlet UITapGestureRecognizer *imagePickerGestureRecogniser;
    id<RecipesTableUpdateDelegate> updaterDelegate;
   NSArray *optionsMenuButtons;
   NSArray *editMenuButtons;
}

@property (nonatomic, assign)id<RecipesTableUpdateDelegate> updaterDelegate;

@property (weak, nonatomic) IBOutlet UIView *editMenuView;
@property (weak, nonatomic) IBOutlet UIView *optionsMenuView;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;
@property (weak, nonatomic) IBOutlet UIToolbar *menuBar;
@property (weak, nonatomic) IBOutlet UIImageView *cameraImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recipeIngredientsHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recipeStepsHeight;
@property (retain, nonatomic) IBOutlet ImageZoomView *imageZoomView;


//Buttons
//Options Menu
@property (weak, nonatomic) IBOutlet UIButton *optionsTrash;
@property (weak, nonatomic) IBOutlet UIButton *optionsLike;
@property (weak, nonatomic) IBOutlet UIButton *optionsEdit;
//Edit Menu
@property (weak, nonatomic) IBOutlet UIButton *editCancel;
@property (weak, nonatomic) IBOutlet UIButton *editSave;


- (IBAction)changeRecipeImage:(id)sender;
- (IBAction)editRecipe:(id)sender;
- (IBAction)addRecipeToFavourite:(id)sender;
- (IBAction)chooseTypeOfDish:(id)sender;
- (IBAction)deleteRecipe:(id)sender;
- (IBAction)saveChanges:(id)sender;
- (IBAction)cancelChanges:(id)sender;

@property id objectId;

@end
