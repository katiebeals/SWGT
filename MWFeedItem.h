//
//  MWFeedItem.h
//  MWFeedParser
//
//  Copyright (c) 2010 Michael Waterfall

#import <Foundation/Foundation.h>

@interface MWFeedItem : NSObject <NSCoding> {
	
	NSString *identifier; // Item identifier
	NSString *title; // Item title
	NSString *link; // Item URL
	NSDate *date; // Date the item was published
	NSDate *updated; // Date the item was updated if available
	NSString *summary; // Description of item - TOAN: currently is full bodyContent
	NSString *lead; // Description of item
	NSString *content; // More detailed content (if available)
	
	NSString *mediaContent;
	NSString *mediaThumbnail;
	NSString *mediaMediumThumbnail;
	NSString *mediaLargeThumbnail;
	NSString *author;
	NSString *authorPhoto;
	
	NSString *mediaVideo;
	NSString *mediaVideoThumbnail;
	
	// Enclosures: Holds 1 or more item enclosures (i.e. podcasts, mp3. pdf, etc)
	//  - NSArray of NSDictionaries with the following keys:
	//     url: where the enclosure is located (NSString)
	//     length: how big it is in bytes (NSNumber)
	//     type: what its type is, a standard MIME type  (NSString)
	NSArray *enclosures;
	
	UIImage *appIcon;

}

@property (nonatomic, retain) UIImage *appIcon;

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSDate *updated;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSArray *enclosures;


@property (nonatomic, copy) NSString *mediaContent;
@property (nonatomic, copy) NSString *mediaThumbnail;
@property (nonatomic, copy) NSString *mediaMediumThumbnail;
@property (nonatomic, copy) NSString *mediaLargeThumbnail;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *authorPhoto;
@property (nonatomic, copy) NSString *mediaVideo;
@property (nonatomic, copy) NSString *mediaVideoThumbnail;

@end
