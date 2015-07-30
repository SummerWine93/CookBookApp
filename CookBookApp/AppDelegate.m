//
//  AppDelegate.m
//  CookBook v1
//
//  Created by User on 6/16/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import "AppDelegate.h"
#import "Recipe.h"
#import "RecipeCategory.h"
#import "RecipesTableViewController.h"
#include "FavouriteRecipesTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [NSThread sleepForTimeInterval:1.0];
    self.window.tintColor = [UIColor darkGrayColor];
    
    self.context = [self managedObjectContext];
    
    
    NSLog(@"Managed object context %@", self.managedObjectContext);
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        UIActivityIndicatorView *loadInfoActivityView = [self loadInfoActivityView];
        [loadInfoActivityView startAnimating];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self firstInit];
        });
        [[NSUserDefaults standardUserDefaults] synchronize];
        [loadInfoActivityView stopAnimating];
    }
    //[self firstInit];
    //[self deleteCategories];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {
    if ([self.context hasChanges]) {
        alert = [[UIAlertView alloc] initWithTitle:@"Unsaved changes" message:@"Do you want to save your data changes?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles: @"YES", nil];
        [alert show];
    }
    self.context = nil;
}

+(AppDelegate *)appDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
            [self.context save:nil];
            alert = [[UIAlertView alloc] initWithTitle:nil message:@"Changes saved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            break;
        default:
            break;
    }
}

-(UIActivityIndicatorView *)loadInfoActivityView{
    UIActivityIndicatorView *loadInfoActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loadInfoActivityView.frame = CGRectMake(0, 0, 40, 40);
    loadInfoActivityView.center = self.window.center;
    [self.window addSubview:loadInfoActivityView];
    [loadInfoActivityView bringSubviewToFront:self.window];
    
    return loadInfoActivityView;
}

#pragma mark - Do this only if you need to initialise the Categories entity on the first app launch
-(void)firstInit{
    NSError *error = nil;
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Categories" ofType:@"json"];
    NSArray *categories = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:kNilOptions error:&error];
    dataPath = [[NSBundle mainBundle] pathForResource:@"Recipes" ofType:@"json"];
    NSArray *recipes = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:kNilOptions error:&error];
    NSLog(@"Imported data: %@", categories);
    NSLog(@"Imported data: %@", recipes);
    NSLog(@"Error: %@", error);
    
    [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        RecipeCategory *category = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeCategory" inManagedObjectContext:self.context];
        [category setValue:[obj objectForKey:@"name"] forKey:@"name"];
        NSLog(@"%@", category.name);
        NSError *error;
        if (![self.context save:&error]) {
            NSLog(@"Error while saving data: %@", error);
        }
    }];
    /*
     RecipeCategory *category = [NSEntityDescription
     insertNewObjectForEntityForName:@"RecipeCategory" inManagedObjectContext: self.context];
     [category setValue:@"First course" forKey:@"name"];
     
     RecipeCategory *category1 = [NSEntityDescription
     insertNewObjectForEntityForName:@"RecipeCategory"      inManagedObjectContext: self.context];
     [category1 setValue:@"Main course" forKey:@"name"];
     
     RecipeCategory *category2 = [NSEntityDescription
     insertNewObjectForEntityForName:@"RecipeCategory"     inManagedObjectContext: self.context];
     [category2 setValue:@"Desserts" forKey:@"name"];
     
     RecipeCategory *category3 = [NSEntityDescription
     insertNewObjectForEntityForName:@"RecipeCategory"      inManagedObjectContext: self.context];
     [category3 setValue:@"Drinks" forKey:@"name"];
     
     RecipeCategory *category4 = [NSEntityDescription
     insertNewObjectForEntityForName:@"RecipeCategory"      inManagedObjectContext: self.context];
     [category4 setValue:@"Salads" forKey:@"name"];
     
     RecipeCategory *category5 = [NSEntityDescription
     insertNewObjectForEntityForName:@"RecipeCategory"      inManagedObjectContext: self.context];
     [category5 setValue:@"Other" forKey:@"name"];
     */
    [self saveContext];
    
}

-(void)deleteCategories{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"RecipeCategory"];
    [request setIncludesPropertyValues:NO];
    NSArray *results = [self.context executeFetchRequest:request error:nil];
    for (NSManagedObject *result in results) {
        [self.context deleteObject:result];
    }
    
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize categoryFetchedResultsController = _categoryFetchedResultsController;

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CookBookApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption: @YES,
                              NSInferMappingModelAutomaticallyOption: @YES,
                              NSSQLitePragmasOption : @{@"journal_mode" : @"DELETE"}
                              };
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CookBookApp.sqlite"];
    NSError *error = nil;
    
    NSString *storePath = [storeURL path];
    /*
     NSLog(@"Error %@", error);
     
     NSString *dbName = @"CookBookData.sqlite";
     NSFileManager *fileManager = [NSFileManager defaultManager];
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
     NSString *documentDirectory = [paths objectAtIndex:0];
     NSString *dbPath = [documentDirectory stringByAppendingString:dbName];
     
     BOOL success = [fileManager fileExistsAtPath:dbPath];
     if (!success) {
     NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
     success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
     if (success) {
     NSLog(@"Success");
     }
     else{
     NSLog(@"Error %@", [error localizedDescription]);
     }
     }
     else {
     NSLog(@"Already exists");
     }
     
     if (![[NSFileManager defaultManager] copyItemAtPath:dbPath toPath:storePath error:&error]) {
     NSLog(@"Couldn't preload data, error: %@", error);
     }*/
    
    // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    // NSString *documentsDir = [paths objectAtIndex:0];
    // NSString *path = [documentsDir stringByAppendingPathComponent:@"CookBookData.sqlite"];
    
    /*NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"CookBookData.sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSLog(@"From:\n %@", defaultDBPath);
    NSLog(@"To:\n %@", storePath);
    if(![fileManager copyItemAtPath:defaultDBPath toPath:storePath error:&error]){
        NSLog(@"!!!Couldn't copy data: %@ \n \n ", error);
        NSLog(@"From:\n %@", defaultDBPath);
        NSLog(@"To:\n %@", storePath);
    }
    if (![fileManager fileExistsAtPath:defaultDBPath]) {
        NSLog(@"No preload file");
    }
    if (![fileManager fileExistsAtPath:storePath]) {
        NSLog(@"No store file");
    }*/
    
    //NSError *error;
    /* NSString *dbName = @"CookBookData.sqlite";
     NSFileManager *fileManager = [NSFileManager defaultManager];
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
     NSString *documentDirectory = [paths objectAtIndex:0];
     NSString *dbPath = [documentDirectory stringByAppendingString:dbName];
     NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
     
     if ([fileManager fileExistsAtPath:defaultDBPath]) { //check if file exists in NSBundle
     
     BOOL success = [fileManager fileExistsAtPath:dbPath]; // check if exists in document directory
     if (!success) {
     
     success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error]; //copy to document directory
     if (success) {
     NSLog(@"Database successfully copied to document directory");
     }
     else{
     NSLog(@"Error %@", [error localizedDescription]);
     }
     }
     else {
     NSLog(@"Already exists in document directory");
     }
     
     }
     else{
     NSLog(@"Does not exists in NSBundle");
     }
     
     */
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

-(NSFetchedResultsController *)fetchedResultsController{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    [NSFetchedResultsController deleteCacheWithName:@"Master"];
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *sortDescriptorCategory = [[NSSortDescriptor alloc] initWithKey:@"category.name" ascending:YES];
    [request setFetchBatchSize:20];
    [request setSortDescriptors:[NSArray arrayWithObjects:sortDescriptorCategory, nil]];
    //NSPredicate *favouritePredicate = [NSPredicate predicateWithFormat:@"isFavourite == %@", [NSNumber numberWithBool:YES]];
    //[request setPredicate:favouritePredicate];
    
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"category.name" cacheName:@"Master"];
    self.fetchedResultsController = controller;
    _fetchedResultsController.delegate = self;
    
    [controller performFetch:nil];
    return _fetchedResultsController;
}

-(NSFetchedResultsController *)categoryFetchedResultsController{
    if (_categoryFetchedResultsController != nil) {
        return _categoryFetchedResultsController;
    }
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RecipeCategory" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [request setFetchBatchSize:20];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [NSFetchedResultsController deleteCacheWithName:@"Master"];
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    self.categoryFetchedResultsController = controller;
    _categoryFetchedResultsController.delegate = self;
    
    [controller performFetch:nil];
    return _categoryFetchedResultsController;
}


#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContextq = self.managedObjectContext;
    if (managedObjectContextq != nil) {
        NSError *error = nil;
        if ([managedObjectContextq hasChanges] && ![managedObjectContextq save:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            alert = [[UIAlertView alloc] initWithTitle:@"App delegate error" message:@"Unable to save your data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            abort();
        }
    }
}

@end