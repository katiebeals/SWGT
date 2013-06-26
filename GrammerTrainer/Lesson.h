

#import <Foundation/Foundation.h>


@interface Lesson : NSObject 

@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, strong) NSNumber *lessonNumber;
@property (nonatomic, strong) NSString *lessonName;
@property (nonatomic, strong) NSString *topic;
@property (nonatomic, strong) NSString *loadFile;
@property (nonatomic, strong) NSString *showMultipleChoice;
@property (nonatomic, strong) NSDictionary *resultsDictionary;

@end
