//
//  PathManager.h
//  CookBookApp
//
//  Created by User on 8/6/15.
//  Copyright (c) 2015 User. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathManager : NSObject{
    NSString *documentsPath;
}

@property (nonatomic, retain) NSString *documentsPath;
+ (NSString *)pathInDocumentsDirectoryForName: (NSString *)fileName;
+ (PathManager *)getInstance;
+(NSString *)documentsPathString;

@end
