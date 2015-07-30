//
//  RecipeCategory.h
//  CookBook v1
//
//  Created by User on 7/24/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Recipe;

@interface RecipeCategory : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSOrderedSet *recipe;
@end

@interface RecipeCategory (CoreDataGeneratedAccessors)

- (void)insertObject:(Recipe *)value inRecipeAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRecipeAtIndex:(NSUInteger)idx;
- (void)insertRecipe:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRecipeAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRecipeAtIndex:(NSUInteger)idx withObject:(Recipe *)value;
- (void)replaceRecipeAtIndexes:(NSIndexSet *)indexes withRecipe:(NSArray *)values;
- (void)addRecipeObject:(Recipe *)value;
- (void)removeRecipeObject:(Recipe *)value;
- (void)addRecipe:(NSOrderedSet *)values;
- (void)removeRecipe:(NSOrderedSet *)values;
@end
