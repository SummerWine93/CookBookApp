//
//  SimpleTableViewCell.h
//  CookBook v1
//
//  Created by User on 7/10/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableViewCell : UITableViewCell 

@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UILabel *recipeName;
@property (weak, nonatomic) IBOutlet UILabel *recipeDetails;
@property (weak, nonatomic) IBOutlet UIButton *recipeIsFavouriteButton;
@end
