//
//  SimpleTableViewCell.m
//  CookBook v1
//
//  Created by User on 7/10/15.
//  Copyright (c) 2015 Delphi LCC. All rights reserved.
//

#import "SimpleTableViewCell.h"

@implementation SimpleTableViewCell

@synthesize recipeImage;
@synthesize recipeName;
@synthesize recipeIsFavouriteButton;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
