     //
//  RecipesTableViewController.m
//  CookBook v1
//
//  Created by User on 6/22/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import "RecipesTableViewController.h"
#import "FavouriteRecipesTableViewController.h"
#import "PathManager.h"
#import "NSString+MD5.h"
#import "FTWCache.h"

@implementation RecipesTableViewController {
    NSMutableDictionary *recipeImages;
}

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize categoryFetchResultsController = _categoryFetchResultsController;

-(void)viewDidLoad{
    [super viewDidLoad];
    
    sharedDelegate = [AppDelegate appDelegate];
    self.managedObjectContext = [sharedDelegate managedObjectContext];
        
    self.fetchedResultsController = [sharedDelegate fetchedResultsController];
    self.fetchedResultsController.delegate = self;
    self.categoryFetchResultsController = [sharedDelegate categoryFetchedResultsController];
    self.categoryFetchResultsController.delegate = self;
    
    [[self fetchedResultsController] performFetch:nil];
    [[self categoryFetchResultsController] performFetch:nil];
    //[self.tableView reloadData];
    
    UINib *cellNib = [UINib nibWithNibName:@"TableCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"TableCell"];
    
    
    [NSFetchedResultsController deleteCacheWithName:nil];    
    [self fillView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UITableView *tableView = self.tableView;
    //[tableView reloadData];
    //[self updateTableView:tableView];
    @try {
        [recipeImages removeObjectForKey:self.imageInCache];
        [self updateTableView:self.tableView];
    }
    @catch (NSException *exception) {
        NSLog(@"Image was not changed");
    }
    
}

-(void)viewDidUnload{
    self.fetchedResultsController = nil;
    self.categoryFetchResultsController = nil;
    [super viewDidUnload];
}

-(void)updateTableView: (UITableView *) tableView {
    [tableView beginUpdates];
    
    [tableView reloadData];
    [self.view setNeedsDisplay];
    [tableView endUpdates];
}

-(void)fillView{
    NSFetchRequest *categoryFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *categoryEntity = [NSEntityDescription entityForName:@"RecipeCategory" inManagedObjectContext:self.managedObjectContext];
    [categoryFetchRequest setEntity:categoryEntity];
    self.categoryFetchResults = [self.managedObjectContext executeFetchRequest:categoryFetchRequest error:nil];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self.fetchedResultsController sections] count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo name];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    Recipe *recipe = [self.fetchedResultsController objectAtIndexPath:path];
    
    if ([segue.identifier isEqualToString:@"showRecipe"]) {
        ShowRecipeViewController *vc = [segue destinationViewController];
        vc.objectId = [recipe objectID];
        NSString *key = [recipe.image MD5Hash];
        vc.imageInCache = [FTWCache objectForKey:key];
        vc.updaterDelegate = self;
    }
    
    RecipeViewController *vc = [segue destinationViewController];
    vc.delegate = self;
    path = nil;
    vc = nil;
    recipe = nil;
}

-(id)copyWithZone:(NSZone *)zone{
    id newCopy = [[[self class]allocWithZone:zone]init];
    
    return newCopy;
}


#pragma mark - Fetched results controller delegate

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
    switch (type) {
       case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
    
}

#pragma mark - Table specific appearence

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"TableCell";
    SimpleTableViewCell *cell;
    if (cell == nil) {
        cell = (SimpleTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:identifier];
    }
    Recipe *cellRecipe = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.recipeName.text = cellRecipe.name;
    cell.recipeDetails.text = cellRecipe.ingredients;
    //NSString *name = [NSString stringWithFormat:@"t_%@", cellRecipe.image];
    UIImage *favourite;
    if ([cellRecipe.isFavourite boolValue] == YES) {
        favourite = [UIImage imageNamed:@"like.png"];
    }
    [cell.recipeIsFavouriteButton setImage:favourite forState:UIControlStateNormal];
    
    
    NSString *key = [cellRecipe.image MD5Hash];
    NSData *data = [FTWCache objectForKey:key];
    if (data) {
        [cell.recipeImage setImage:[UIImage imageWithData:data]];
    }
    else{
        cell.recipeImage.image = [UIImage imageNamed:@"loading-placeholder.jpg"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSString *path = [PathManager pathInDocumentsDirectoryForName: cellRecipe.image];
            UIImage *image;
            if([[NSFileManager defaultManager] fileExistsAtPath:path]){
                image = [ImageProcessor createThumbnailImageFromImage:[UIImage imageWithContentsOfFile:path]];
            }
            else{
                image = [ImageProcessor createThumbnailImageFromImage:[UIImage imageNamed:cellRecipe.image]];
            }
            [FTWCache setObject:UIImagePNGRepresentation(image) forKey:key];
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.recipeImage setImage:image];
            });
        });
    }
    favourite = nil;
    cellRecipe = nil;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showRecipe" sender:self];
}

-(void)dealloc{
    self.fetchedResultsController = nil;
    self.categoryFetchResultsController = nil;
    [self.managedObjectContext reset];
    self.managedObjectContext = nil;
    self.categoryFetchResults = nil;
    
}

-(void)removeImageFromCache:(id)imageInCache{
    @try {
        [FTWCache removeObjectForKey:self.imageInCache];
        //[recipeImages ];
    }
    @catch (NSException *exception) {}
    [self.tableView reloadData];
    [self.view setNeedsDisplay];
}

@end
