//
//  MWFeedInfo.h
//  MWFeedParser
//
//  Copyright (c) 2010 Michael Waterfall
//  
//

#import <Foundation/Foundation.h>

@interface MWFeedInfo : NSObject <NSCoding> {
	
	NSString *title; // Feed title
	NSString *link; // Feed link
	NSString *summary; // Feed summary / description
	
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *summary;

@end
