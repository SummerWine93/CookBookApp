//
//  AppDelegate.m
//  CookBookApp
//
//  Created by User on 7/30/15.
//  Copyright (c) 2015 User. All rights reserved.
//

#import "AppDelegate.h"
#import "RecipeCategory.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+(AppDelegate *)appDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [NSThread sleepForTimeInterval:1.0];
    self.window.tintColor = [UIColor darkGrayColor];
    
    self.context = [self managedObjectContext];
    
    
    NSLog(@"Managed object context %@", self.managedObjectContext);
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //[self firstInit];
        });
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //[self firstInit];
    //[self deleteCategories];
    
    return YES;
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


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize categoryFetchedResultsController = _categoryFetchedResultsController;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Delphi.CookBookApp" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CookBookApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CookBookApp.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
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
    [NSFetchedResultsController deleteCacheWithName:@"Master2"];
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master2"];
    self.categoryFetchedResultsController = controller;
    _categoryFetchedResultsController.delegate = self;
    
    [controller performFetch:nil];
    return _categoryFetchedResultsController;
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

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
