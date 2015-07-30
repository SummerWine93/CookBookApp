//
//  RecipeCategory.h
//  CookBookApp
//
//  Created by User on 7/30/15.
//  Copyright (c) 2015 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Recipe;

@interface RecipeCategory : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *recipe;
@end

@interface RecipeCategory (CoreDataGeneratedAccessors)

- (void)addRecipeObject:(Recipe *)value;
- (void)removeRecipeObject:(Recipe *)value;
- (void)addRecipe:(NSSet *)values;
- (void)removeRecipe:(NSSet *)values;

@end
