
/*
     File: Module.h
 Abstract: A simple model class to represent a play with a name and a collection of quotations.
 
  Version: 2.0
  
 Copyright (C) 2011 Apple Inc. All Rights Reserved.
 
 */

#import <Foundation/Foundation.h>


@interface Module : NSObject 

@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, strong) NSNumber *moduleNumber;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *lessons;

@end
