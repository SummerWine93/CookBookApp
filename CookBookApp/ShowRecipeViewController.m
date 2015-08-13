//
//  ShowRecipetViewController.m
//  CookBook v1
//
//  Created by User on 6/19/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import "ShowRecipeViewController.h"
#import "FullSizeImageViewController.h"
#include <XLMediaZoom.h>
#import "PathManager.h"
#import "ImageZoomView.h"

@interface ShowRecipeViewController (){
    Recipe *object;
    BOOL imageWasChanged;
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
    
    if (self.optionsMenuView.isHidden) {
        [self switchEditingModeView];
    }
    imageWasChanged = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadInputViews];
    //[self.navigationController setToolbarHidden:NO];
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
    imageWasChanged = NO;
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
            case 1:{
                object = [context existingObjectWithID:self.objectId error:nil];
                
                NSError *error = nil;
                NSString *imagePath = [PathManager pathInDocumentsDirectoryForName:object.image];
                [[NSFileManager defaultManager] removeItemAtPath:imagePath error:&error];                
                [context deleteObject:object];
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
    if (imageWasChanged) {
        [self setImageForObject: object];
    }
}


-(IBAction)imageTapped:(id)sender{
    if (self.optionsMenuView.isHidden) {
        [self changeRecipeImage:object];
        imageWasChanged = YES;
    }
    else{
        FullSizeImageViewController *imageViewController = [FullSizeImageViewController new];
        imageViewController.scrollView = self.scrollView;
        imageViewController.imageName = object.name;
        //self.iv = [[UIImageView alloc] initWithImage:self.recipeImage.image];
        self.iv = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 10, self.view.frame.origin.y + 100, 300, 300)];
        [self.iv setImage:self.recipeImage.image];
        //self.iv.backgroundColor = [UIColor redColor];
        //self.scrollView.backgroundColor = [UIColor blackColor];
        //[self.navigationController.topViewController.view addSubview:self.iv];
        //XLMediaZoom *imageZoom = [[XLMediaZoom alloc] initWithAnimationTime:@(0.2) image:self.iv blurEffect:YES];
        //[imageZoom setPreservesSuperviewLayoutMargins:YES];
        //[self.navigationController.topViewController.view addSubview:imageZoom];
        //[imageZoom show];
        
        ImageZoomView *izv = [[ImageZoomView alloc] initWithFrame:
                              CGRectMake(self.view.frame.origin.x,
                                         self.view.frame.origin.y,
                                         self.view.frame.size.width,
                                         self.view.frame.size.height) andImage:self.recipeImage.image];
        [self.navigationController.topViewController.view addSubview:izv];
        
        
        //alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:@"IMAGE" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[alert setFrame:CGRectMake(self.view.frame.origin.x + 10, self.view.frame.origin.y + 100, self.view.frame.size.width - 10, 300)];
        if (floor(NSFoundationVersionNumber)>NSFoundationVersionNumber_iOS_6_1) {
            [alert setValue:self.iv forKey:@"accessoryView"];
        }
        else{
            [alert addSubview:self.iv];
        }
        [alert show];
        alert.frame = CGRectMake(self.view.frame.origin.x + 10, self.view.frame.origin.y + 100, self.view.frame.size.width - 10, 300);
        
        [self.view setNeedsDisplay];
        NSLog(@"Click!");
        
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    if (self.optionsMenuView.isHidden) {
        //[self switchEditingModeView];
    }
    [super viewDidDisappear:animated];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [self switchEditingModeView];
    NSLog(@"SEGUE");
}

@end
