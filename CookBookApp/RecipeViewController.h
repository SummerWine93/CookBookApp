//
//  ReceiptViewController.h
//  CookBook v1
//
//  Created by User on 6/24/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "AppDelegate.h"
#import "Recipe.h"
#import "RecipeCategory.h"
#import "ImageProcessor.h"

@class RecipesTableViewController;

@protocol RecipeChangedDelegate <NSObject>

-(void)notifyItSomehow;

@end

@interface RecipeViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>{
    NSMutableArray *pickerData;
    UITapGestureRecognizer *singleTap;
    UIAlertView *alert;
    NSString *neededEntityName;
    id typeOfDish;
    BOOL typeOfDishChanged;
}

@property id<RecipeChangedDelegate> delegate;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *categoryFetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *recipeName;
@property (weak, nonatomic) IBOutlet UIButton *typeOfDish;
@property (weak, nonatomic) IBOutlet UITextView *recipeIngredients;
@property (weak, nonatomic) IBOutlet UITextView *recipeSteps;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;

@property (weak, nonatomic) IBOutlet UIImageView *loadImageView;
@property (weak, nonatomic) IBOutlet UIView *optionsView;

@property (weak, nonatomic) IBOutlet UIView *typePickerView;
@property RecipesTableViewController *correspondingTableViewController;
@property (weak, nonatomic) IBOutlet UITableView *categoryTable;

@property (strong) NSString *nameId;

- (IBAction)changeRecipeImage:(id)sender;
- (void)insertNewObject:(id)sender;
- (void)insertData: (NSManagedObject *)newManagedObject withContext: (NSManagedObjectContext *)context;
- (void)setTypeOfDishForObject: (NSManagedObject *)newManagedObject;
- (void)setImageForObject: (NSManagedObject *)newManagedObject;

@end

