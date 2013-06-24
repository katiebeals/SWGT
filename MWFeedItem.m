//
//  MWFeedItem.m
//  MWFeedParser
//
//

#import "MWFeedItem.h"

#define EXCERPT(str, len) (([str length] > len) ? [[str substringToIndex:len-1] stringByAppendingString:@"…"] : str)

@implementation MWFeedItem

@synthesize identifier, title, link, date, updated, summary, content, enclosures, lead;
@synthesize mediaContent, mediaThumbnail, mediaMediumThumbnail, mediaLargeThumbnail, author, authorPhoto;
@synthesize mediaVideo, mediaVideoThumbnail, appIcon;

#pragma mark NSObject

- (NSString *)description {
	NSMutableString *string = [[NSMutableString alloc] initWithString:@"MWFeedItem: "];
	if (title)   [string appendFormat:@"“%@”", EXCERPT(title, 50)];
	if (date)    [string appendFormat:@" - %@", date];
	//if (link)    [string appendFormat:@" (%@)", link];
	//if (summary) [string appendFormat:@", %@", EXCERPT(summary, 50)];
	return [string autorelease];
}

- (void)dealloc {
	[appIcon release];
	[identifier release];
	[title release];
	[link release];
	[date release];
	[updated release];
	[summary release];
	[content release];
	[enclosures release];
	[lead release];
	
	[mediaContent release];
	[mediaThumbnail release];
	[mediaMediumThumbnail release];
	[mediaLargeThumbnail release];
	[author	release];
	[authorPhoto release];
	
	[mediaVideo release];
	[mediaVideoThumbnail release];
	
	[super dealloc];
}

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		identifier = [[decoder decodeObjectForKey:@"identifier"] retain];
		title = [[decoder decodeObjectForKey:@"title"] retain];
		link = [[decoder decodeObjectForKey:@"link"] retain];
		date = [[decoder decodeObjectForKey:@"date"] retain];
		updated = [[decoder decodeObjectForKey:@"updated"] retain];
		summary = [[decoder decodeObjectForKey:@"summary"] retain];
		lead = [[decoder decodeObjectForKey:@"lead"] retain];		
		content = [[decoder decodeObjectForKey:@"content"] retain];
		enclosures = [[decoder decodeObjectForKey:@"enclosures"] retain];
		
		mediaContent = [[decoder decodeObjectForKey:@"mediaContent"] retain];
		mediaThumbnail = [[decoder decodeObjectForKey:@"mediaThumbnail"] retain];
		mediaMediumThumbnail = [[decoder decodeObjectForKey:@"mediaMediumThumbnail"] retain];
		mediaLargeThumbnail = [[decoder decodeObjectForKey:@"mediaLargeThumbnail"] retain];
		author = [[decoder decodeObjectForKey:@"author"] retain];
		authorPhoto = [[decoder decodeObjectForKey:@"authorPhoto"] retain];

		mediaVideo = [[decoder decodeObjectForKey:@"mediaVideo"] retain];
		mediaVideoThumbnail = [[decoder decodeObjectForKey:@"mediaVideoThumbnail"] retain];

	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	if (identifier) [encoder encodeObject:identifier forKey:@"identifier"];
	if (title) [encoder encodeObject:title forKey:@"title"];
	if (link) [encoder encodeObject:link forKey:@"link"];
	if (date) [encoder encodeObject:date forKey:@"date"];
	if (updated) [encoder encodeObject:updated forKey:@"updated"];
	if (summary) [encoder encodeObject:summary forKey:@"summary"];
	if (lead) [encoder encodeObject:lead forKey:@"lead"];
	if (content) [encoder encodeObject:content forKey:@"content"];
	if (enclosures) [encoder encodeObject:enclosures forKey:@"enclosures"];
	
	if (mediaContent) [encoder encodeObject:mediaContent forKey:@"mediaContent"];
	if (mediaThumbnail) [encoder encodeObject:mediaThumbnail forKey:@"mediaThumbnail"];
	if (mediaMediumThumbnail) [encoder encodeObject:mediaMediumThumbnail forKey:@"mediaMediumThumbnail"];
	if (mediaLargeThumbnail) [encoder encodeObject:mediaLargeThumbnail forKey:@"mediaLargeThumbnail"];
	if (author) [encoder encodeObject:author forKey:@"author"];
	if (authorPhoto) [encoder encodeObject:authorPhoto forKey:@"authorPhoto"];
	
	if (mediaVideo) [encoder encodeObject:mediaVideo forKey:@"mediaVideo"];
	if (mediaVideoThumbnail) [encoder encodeObject:mediaVideoThumbnail forKey:@"mediaVideoThumbnail"];
	
}

@end
