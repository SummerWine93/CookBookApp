//
//  PathManager.m
//  CookBookApp
//
//  Created by User on 8/6/15.
//  Copyright (c) 2015 User. All rights reserved.
//

#import "PathManager.h"

@implementation PathManager


+(NSString *)documentsPathString{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)pathInDocumentsDirectoryForName: (NSString *)fileName{   
    return [[self documentsPathString] stringByAppendingPathComponent:fileName];
}

+(PathManager *)getInstance{
    static PathManager *sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

-(PathManager *)init{
    if (self = [super init]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsPath = [paths objectAtIndex:0];
    }
    return self;
}

@end
