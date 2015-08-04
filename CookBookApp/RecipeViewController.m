//
//  ReceiptViewController.m
//  CookBook v1
//
//  Created by User on 6/24/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import "RecipeViewController.h"
#import "RecipesTableViewController.h"
#include <stdlib.h>
#import "ImageProcessor.h"
#import <ImageIO/ImageIO.h>

@interface RecipeViewController ()

@end

@implementation RecipeViewController

@synthesize correspondingTableViewController;

- (void)viewDidLoad {
    [super viewDidLoad];    
    pickerData = [NSMutableArray new];
    self.correspondingTableViewController = [RecipesTableViewController new];
    self.typeOfDish.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.typeOfDish.titleLabel.minimumScaleFactor = 0.5;
        
    AppDelegate *sharedDelegate = [AppDelegate appDelegate];
    self.managedObjectContext = [sharedDelegate managedObjectContext];
    self.fetchedResultsController = [sharedDelegate fetchedResultsController];
    self.fetchedResultsController.delegate = self;
    self.categoryFetchedResultsController = [sharedDelegate categoryFetchedResultsController];
    self.categoryFetchedResultsController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectDidChange:) name:NSManagedObjectContextDidSaveNotification object:nil];
         NSArray *categories  = [self.categoryFetchedResultsController fetchedObjects];
    
    for (RecipeCategory* key in categories) {
        [pickerData addObject:key.name];
    }
    
    self.typePickerView.layer.cornerRadius = 5;
    
    [self.recipeSteps scrollRangeToVisible:NSMakeRange(0, 1)];
    [self.recipeIngredients scrollRangeToVisible:NSMakeRange(0, 1)];
    
    self.recipeName.inputAccessoryView = [self toolBar];
    self.recipeSteps.inputAccessoryView = [self toolBar];
    self.recipeIngredients.inputAccessoryView = [self toolBar];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    for (NSManagedObject *object in [self fetchedResultsController].fetchedObjects) {
        NSLog(@"%@", [object valueForKey:@"name"]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
            [self capturePhoto];
            break;
        case 2:
            [self loadPhotoFromGallery];
            break;
        default:
            break;
    }
}

#pragma mark - Image Setting Stuff

- (IBAction)changeRecipeImage:(id)sender {
    alert = [[UIAlertView alloc] initWithTitle:@"Image picker" message:@"Set your own image" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Capture a photo", @"Load from gallery", nil];
    [alert show];
}

-(void)loadPhotoFromGallery{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

-(void)capturePhoto{
    NSLog(@"Capture a photo");
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *cameraAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [cameraAlert show];
        return;
    }
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{    
    UIImage *bufferImage = info[UIImagePickerControllerOriginalImage];
    self.recipeImage.image = bufferImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)dataAddedMessCleanUp{
    alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Recipe added" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    self.recipeName.text = nil;
    self.recipeIngredients.text = nil;
    self.recipeSteps.text = nil;
}

#pragma mark - pickerView

- (IBAction)chooseTypeOfDish:(id)sender {
    NSLog(@"Changing type of dish...");
    self.typePickerView.hidden = !self.typePickerView.isHidden;
}

#pragma mark - Insert Core Data Object

- (void)insertNewObject:(id)sender {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    [self insertData:newManagedObject withContext:context];
    [self.fetchedResultsController performFetch:nil];
}

-(void)insertData: (NSManagedObject *)newManagedObject withContext: (NSManagedObjectContext *)context{
    [newManagedObject setValue:self.recipeName.text forKey:@"name"];
    [newManagedObject setValue:self.recipeSteps.text forKey:@"steps"];
    [newManagedObject setValue:self.recipeIngredients.text forKey:@"ingredients"];
    [newManagedObject setValue:@NO forKey:@"isFavourite"];
    [newManagedObject setValue:@YES forKey:@"isUserGenerated"];
    
    NSString *UUID = [[NSUUID UUID] UUIDString];
    [newManagedObject setValue:UUID forKey:@"recipeId"];
    
    [self setTypeOfDishForObject:newManagedObject];
    [self setImageForObject:newManagedObject];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        alert = [[UIAlertView alloc] initWithTitle:@"Recipe error"
                                          message:@"Couldn't save your data"
                                          delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
        [alert show];
        // to make context see the changes
        [context refreshObject:newManagedObject mergeChanges:NO];        
    }
    else{
        [self dataAddedMessCleanUp];
    }
    [self.managedObjectContext save:nil];
    [self.fetchedResultsController performFetch:nil];
}

-(void)setTypeOfDishForObject: (NSManagedObject *)newManagedObject{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    neededEntityName = @"RecipeCategory";
    NSEntityDescription *entityC = [NSEntityDescription entityForName:neededEntityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entityC];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", self.typeOfDish.titleLabel.text];
    [fetchRequest setPredicate:predicate];
    NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    id type;
    for (RecipeCategory *key in fetchResults) {
        type = key;
    }
    [newManagedObject setValue:type forKey:@"category"];
    [self.managedObjectContext save:nil];
}

-(void)setImageForObject: (NSManagedObject *)newManagedObject{
    if ([newManagedObject valueForKey:@"recipeId"] == nil) {
        NSString *UUID = [[NSUUID UUID] UUIDString];
        [newManagedObject setValue:UUID forKey:@"recipeId"];
    }
    
    if (self.recipeImage.image != nil) {
        //NSUInteger randomValueForName = arc4random_uniform((unsigned)RAND_MAX + 1);
        //NSString *name = [NSString stringWithFormat:@"img_%lu.png", (unsigned long)randomValueForName];
        NSString *name = [NSString stringWithFormat:@"img_%@.png", [newManagedObject valueForKey:@"recipeId"]];
        [newManagedObject setValue:name forKey:@"image"];
        //Creating the image to be used later
        [ImageProcessor createImageFromImage: self.recipeImage.image WithName: name Thumbnail:NO];
    }
    [self.managedObjectContext save:nil];
}

#pragma mark - Fetched results controller


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.managedObjectContext save:nil];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            break;
        case NSFetchedResultsChangeDelete:
            break;
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath{
    [self.fetchedResultsController performFetch:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
    if ([segue.identifier isEqualToString:@"showRecipe"]||[[segue destinationViewController] isKindOfClass:[RecipesTableViewController class]]) {
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
    }
}

-(void)managedObjectDidChange:(NSNotification *)nofication{
    [self.managedObjectContext performBlock:^{
        [self.managedObjectContext mergeChangesFromContextDidSaveNotification:nofication];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.categoryFetchedResultsController fetchedObjects] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[self.categoryTable dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    RecipeCategory *category = [[self.categoryFetchedResultsController fetchedObjects] objectAtIndex: indexPath.row];
    cell.textLabel.text = category.name;
    
    return cell;
}

- (IBAction)chooseSelectedTypeOfDish:(id)sender {
    if ([self.categoryTable indexPathForSelectedRow] != nil) {
        self.typeOfDish.titleLabel.text = [self.categoryTable cellForRowAtIndexPath:[self.categoryTable indexPathForSelectedRow]].textLabel.text;
        self.typePickerView.hidden = YES;
    }
    typeOfDishChanged = YES;
}

-(void)dealloc{
    self.fetchedResultsController = nil;
    [self.managedObjectContext reset];
    self.managedObjectContext = nil;
    self.categoryFetchedResultsController = nil;
}

-(UIToolbar *)toolBar{
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolBar.translucent = YES;
    toolBar.barTintColor = [UIColor lightGrayColor];;
    toolBar.items = @[[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(hideKeypad)]];
    return toolBar;
}

-(IBAction)hideKeypad{
    NSLog(@"Keyboard hidden!");
    [self.view endEditing:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.categoryTable indexPathForSelectedRow] != nil) {
        self.typeOfDish.titleLabel.text = [self.categoryTable cellForRowAtIndexPath:[self.categoryTable indexPathForSelectedRow]].textLabel.text;
        self.typePickerView.hidden = YES;
    }
    typeOfDishChanged = YES;
}


@end
