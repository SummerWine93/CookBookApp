//
//  ShowRecipetViewController.m
//  CookBook v1
//
//  Created by User on 6/19/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import "ShowRecipeViewController.h"
#include <XLMediaZoom.h>
#import "PathManager.h"
#import "ImageZoomView.h"

@interface ShowRecipeViewController (){
    Recipe *recipe;
    BOOL imageWasChanged;
}
@end


@implementation ShowRecipeViewController

const int deleteAlertTag = 999;

-(void)viewDidLoad{    
    self.recipeName.text = self.nameId;
    [super viewDidLoad];
    [self.recipeImage setValue:nil forKey:@"image"];
    [self.recipeImage addObserver:self forKeyPath:@"image" options:0 context:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fillThePageWithData];
    });
    [self useFavouriteViewSettings];
    self.optionsView.layer.cornerRadius = 5;
    self.recipeSteps.delegate = self;
    self.recipeIngredients.delegate = self;
    
    if (self.optionsMenuView.isHidden) {
        [self switchEditingModeView];
    }
    imageWasChanged = NO;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadInputViews];
    
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
    imageWasChanged = NO;
}


- (IBAction)addRecipeToFavourite:(id)sender {
    if([recipe.isFavourite boolValue]) {
        recipe.isFavourite = @0;
    }
    else{
        recipe.isFavourite = @1;
    }
    [self useFavouriteViewSettings];
    NSLog(@"Favourite: %@", recipe.isFavourite);
}


-(void)useFavouriteViewSettings{
    if([recipe.isFavourite boolValue]) {
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
            case 1:{
                @try {
                    [self.recipeImage removeObserver:self forKeyPath:@"image"];
                }
                @catch (NSException *exception) { }
                recipe = [context existingObjectWithID:self.objectId error:nil];                
                NSError *error = nil;
                NSString *imagePath = [PathManager pathInDocumentsDirectoryForName:recipe.image];
                [[NSFileManager defaultManager] removeItemAtPath:imagePath error:&error];                
                [context deleteObject:recipe];
                [context save:nil];
                
                alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:@"The recipe is deleted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [self.navigationController popToRootViewControllerAnimated:YES];
                break;
            }
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
    [self switchEditingModeView];
    [self viewDidLoad];    
}

#pragma mark -
#pragma mark gestureRecogniser

-(void)singleTapGestureCaptured:(UITapGestureRecognizer*)gesture{
    NSLog(@"GESTURE RECOGNISER #1");
    self.typePickerView.hidden = YES;
}

#pragma mark - Core Data fill in the info

-(void)fillThePageWithData{    
    context = [self.fetchedResultsController managedObjectContext];
    recipe = [context existingObjectWithID:self.objectId error:nil];
    
    self.recipeName.text = recipe.name;
    self.recipeIngredients.text = recipe.ingredients;
        self.recipeSteps.text = recipe.steps;
    [self.typeOfDish setTitle:recipe.category.name forState:UIControlStateNormal];
    // Loading the image
    NSString *path = [PathManager pathInDocumentsDirectoryForName:recipe.image];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if (image != nil) {
        self.recipeImage.image = image;
    }
    // if there is no image the app loads a fefault one for it and sets it as recipeImage
    else{
        [self.recipeImage setValue:[UIImage imageNamed:recipe.image] forKey:@"image"];        
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
    recipe.name = self.recipeName.text;
    recipe.ingredients = self.recipeIngredients.text;
    recipe.steps = self.recipeSteps.text;
    if (typeOfDishChanged) {
        [self setTypeOfDishForObject: recipe];
    }
    if (imageWasChanged) {
        [self setImageForObject: recipe];
    }
}


-(IBAction)imageTapped:(id)sender{
    if (self.optionsMenuView.isHidden) {
        [self changeRecipeImage:recipe];
        imageWasChanged = YES;
    }
    else{
        //XLMediaZoom *imageZoom = [[XLMediaZoom alloc] initWithAnimationTime:@(0.2) image:self.iv blurEffect:YES];
        //[imageZoom setPreservesSuperviewLayoutMargins:YES];
        //[self.navigationController.topViewController.view addSubview:imageZoom];
        //[imageZoom show];
        [self addZoomedImageView];
        [self.view setNeedsDisplay];
        NSLog(@"Click!");
    }
}

-(void)addZoomedImageView{
    self.imageZoomView = [[ImageZoomView alloc] initWithFrame:
                          CGRectMake(self.view.frame.origin.x,
                                     self.view.frame.origin.y,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height) andImage:self.recipeImage.image];
    [self.imageZoomView becomeFirstResponder];
    UITapGestureRecognizer *tapRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeZoomedView)];
    [self.imageZoomView addGestureRecognizer:tapRecogniser];
    self.imageZoomView.hidden = NO;
    [self.navigationController.topViewController.view addSubview:self.imageZoomView];
}


-(void)closeZoomedView{
    NSLog(@"Close zoomed view");
    self.imageZoomView.hidden = YES;
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self.imageZoomView setHidden:YES];
    self.imageZoomView = nil;
    //[self viewDidAppear:YES];
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self addZoomedImageView];
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}


-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    @try {
        [self.recipeImage removeObserver:self forKeyPath:@"image"];
    }
    @catch (NSException *exception) { }
}

-(void)viewDidDisappear:(BOOL)animated{    
    [super viewDidDisappear:animated];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [self switchEditingModeView];
    NSLog(@"SEGUE");
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"image"]) {
        NSLog(@"Image was changed");
        [self setRecipeImage: self.recipeImage];
    }
}

@end
