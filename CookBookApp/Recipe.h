//
//  Recipe.h
//  CookBook v1
//
//  Created by User on 7/24/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RecipeCategory;

@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSNumber * cookingTime;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSString * ingredients;
@property (nonatomic, retain) NSNumber * isFavourite;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * steps;
@property (nonatomic, retain) NSNumber * isUserGenerated;
@property (nonatomic, retain) NSDate * timeOfCreation;
@property (nonatomic, retain) RecipeCategory *category;

@end
