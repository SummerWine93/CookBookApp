//
//  Recipe.m
//  CookBookApp
//
//  Created by User on 7/30/15.
//  Copyright (c) 2015 User. All rights reserved.
//

#import "Recipe.h"
#import "RecipeCategory.h"


@implementation Recipe

@dynamic cookingTime;
@dynamic image;
@dynamic ingredients;
@dynamic isFavourite;
@dynamic isUserGenerated;
@dynamic name;
@dynamic steps;
@dynamic timeOfCreation;
@dynamic category;
@dynamic recipeId;

-(id)init{
    return [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext];
}

@end

