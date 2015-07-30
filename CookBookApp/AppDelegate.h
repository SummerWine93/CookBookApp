//
//  AppDelegate.h
//  CookBook v1
//
//  Created by User on 6/16/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSFetchedResultsControllerDelegate>{
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    UIAlertView *alert;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSFetchedResultsController *categoryFetchedResultsController;
@property NSManagedObjectContext *context;
@property BOOL showFavouriteOnly;

-(void)saveContext;
-(NSURL *)applicationsDocumentsDirectory;
+(AppDelegate *)appDelegate;

@end

