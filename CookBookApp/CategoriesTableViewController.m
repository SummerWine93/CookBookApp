//
//  CategoriesTableViewController.m
//  CookBook v1
//
//  Created by User on 7/23/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import "CategoriesTableViewController.h"

@interface CategoriesTableViewController ()

@end


@implementation CategoriesTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize categoryFetchResultsController = _categoryFetchResultsController;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    sharedDelegate = [AppDelegate appDelegate];
    self.managedObjectContext = [sharedDelegate managedObjectContext];
    
    self.categoryFetchResultsController = [sharedDelegate categoryFetchedResultsController];
    self.categoryFetchResultsController.delegate = self;
    
    [[self categoryFetchResultsController] performFetch:nil];
    [self.tableView reloadData];
    
    //UINib *cellNib = [UINib nibWithNibName:@"TableCell" bundle:nil];
    //[self.tableView registerNib:cellNib forCellReuseIdentifier:@"TableCell"];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateTableView: (UITableView *) tableView {
    [tableView beginUpdates];
    
    [tableView reloadData];
    [self.view setNeedsDisplay];
    [tableView endUpdates];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [[self.categoryFetchResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id sectionInfo = [[self.categoryFetchResultsController sections] objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoriesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    RecipeCategory *category = [[self.categoryFetchResultsController fetchedObjects] objectAtIndex:indexPath.row];
    
    cell.label.text = category.name;
    NSString *imageName = [NSString stringWithFormat:@"%@.png", category.name];
    cell.image.image = [UIImage imageNamed:imageName];    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    AllRecipesTableViewController *vc = [segue destinationViewController];
    
    vc.categoryPredicateData = [[[self.categoryFetchResultsController fetchedObjects] objectAtIndex:path.row] name];
    
    
}


@end
