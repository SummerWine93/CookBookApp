//
//  PathManager.m
//  CookBookApp
//
//  Created by User on 8/6/15.
//  Copyright (c) 2015 User. All rights reserved.
//

#import "PathManager.h"

@implementation PathManager

+ (NSString *)pathInDocumentsDirectoryForName: (NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    return path;
}

@end
