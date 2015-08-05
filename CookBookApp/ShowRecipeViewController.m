//
//  ShowRecipetViewController.m
//  CookBook v1
//
//  Created by User on 6/19/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import "ShowRecipeViewController.h"
#import "FullSizeImageViewController.h"

@interface ShowRecipeViewController (){
    Recipe *object;    
}


@end


@implementation ShowRecipeViewController

const int deleteAlertTag = 999;

@synthesize recipeName = _recipeName;

-(void)viewDidLoad{    
    self.recipeName.text = self.nameId;
    [super viewDidLoad];
    [self fillThePageWithData];
    [self useFavouriteViewSettings];
    self.optionsView.layer.cornerRadius = 5;
    
    self.recipeSteps.delegate = self;
    self.recipeIngredients.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadInputViews];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Touches began");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

#pragma mark -
#pragma mark specificOptions

- (IBAction)editRecipe:(id)sender {
    [self switchEditingModeView];
}

-(void)switchEditingModeView{
    self.optionsMenuView.hidden = !self.optionsMenuView.isHidden;
    self.recipeName.editable = !self.recipeName.isEditable;
    self.editMenuView.hidden = !self.editMenuView.isHidden;
    self.loadImageView.hidden = !self.loadImageView.isHidden;
    self.recipeIngredients.editable = !self.recipeIngredients.isEditable;
    self.recipeSteps.editable = !self.recipeSteps.isEditable;
    self.recipeImage.userInteractionEnabled = !self.recipeImage.isUserInteractionEnabled;
    self.typeOfDish.userInteractionEnabled = !self.typeOfDish.isUserInteractionEnabled;
    imagePickerGestureRecogniser.enabled = YES;
    self.typePickerView.hidden = YES;
}

- (IBAction)addRecipeToFavourite:(id)sender {
    if([object.isFavourite boolValue]) {
        object.isFavourite = @0;
    }
    else{
        object.isFavourite = @1;        
    }
    [self useFavouriteViewSettings];
    NSLog(@"Favourite: %@", object.isFavourite);
}

-(void)useFavouriteViewSettings{
    if([object.isFavourite boolValue]) {
        [self.favouriteButton setImage:[UIImage imageNamed:@"fav-delete.png"] forState:UIControlStateNormal];
    }
    else{
        [self.favouriteButton setImage:[UIImage imageNamed:@"fav-add.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)deleteRecipe:(id)sender{
    alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Do you want to delete this recipe?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alert setTag:deleteAlertTag];
    [alert show];
    
    [self.fetchedResultsController performFetch:nil];
    [self.managedObjectContext save:nil];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView.title  isEqual: @"Warning"]) {
        switch (buttonIndex) {
            case 1:
                object = [context existingObjectWithID:self.objectId error:nil];
                [context deleteObject:object];
                [context save:nil];
                
                alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:@"The recipe is deleted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [self.navigationController popToRootViewControllerAnimated:YES];
                break;
            default:
                break;
        }
    }
    else{
        [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    }
}

- (IBAction)saveChanges:(id)sender {
    [self updateRecipe];
    alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:@"The recipe is saved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [self switchEditingModeView];
    [self viewDidLoad];
}

- (IBAction)cancelChanges:(id)sender {
    [self viewDidLoad];
    [self switchEditingModeView];
}

#pragma mark -
#pragma mark gestureRecogniser

-(void)singleTapGestureCaptured:(UITapGestureRecognizer*)gesture{
    self.typePickerView.hidden = YES;
}

#pragma mark - Core Data fill in the info

-(void)fillThePageWithData{    
    context = [self.fetchedResultsController managedObjectContext];
    object = [context existingObjectWithID:self.objectId error:nil];
    
    self.recipeName.text = object.name;
    self.recipeIngredients.text = object.ingredients;
        self.recipeSteps.text = object.steps;
    [self.typeOfDish setTitle:object.category.name forState:UIControlStateNormal];
    // Loading the image
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:object.image];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if (image != nil) {
        self.recipeImage.image = image;
    }
    // if there is no image the app loads a fefault one for it and sets it as recipeImage
    else{
        //NSString *imageName = [[NSString stringWithFormat:@"%@.png", object.name] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.recipeImage.image = [UIImage imageNamed:object.image];
        if (self.recipeImage.image == nil) {
            self.recipeImage.image = [UIImage imageNamed:@"defaultImage.jpg"];
        }       
        
        [self.view setNeedsDisplay];
        [self updateRecipe];
    }
    // Here the size for the textbox is set dynamically
    CGSize sizeForRecipeSteps = [self.recipeSteps sizeThatFits: self.recipeSteps.textContainer.size];
    self.recipeStepsHeight.constant = sizeForRecipeSteps.height;
    [self.recipeSteps.layoutManager ensureLayoutForTextContainer:self.recipeSteps.textContainer];
    CGSize sizeForRecipeIngredients = [self.recipeIngredients sizeThatFits:self.recipeIngredients.textContainer.size];
    self.recipeIngredientsHeight.constant = sizeForRecipeIngredients.height;
    [self.recipeIngredients.layoutManager ensureLayoutForTextContainer:self.recipeIngredients.textContainer];
}

-(void)updateRecipe{
        
    object.name = self.recipeName.text;
    object.ingredients = self.recipeIngredients.text;
    object.steps = self.recipeSteps.text;
    if (typeOfDishChanged) {
        [self setTypeOfDishForObject: object];
    }
    [self setImageForObject:object];    
}


-(IBAction)imageTapped:(id)sender{
    if (self.optionsMenuView.isHidden) {
        [self changeRecipeImage:object];
    }
    else{
        FullSizeImageViewController *imageViewController = [FullSizeImageViewController new];
        self.scrollView.hidden = NO;
        imageViewController.scrollView = self.scrollView;
        //imageViewController
        
    }
}


@end
