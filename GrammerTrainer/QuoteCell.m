
/*
     File: QuoteCell.m
 Abstract: Table view cell to display information about a news item.
 The cell is configured in QuoteCell.xib.
 
  Version: 2.0
  
 Copyright (C) 2011 Apple Inc. All Rights Reserved.
 
 */

#import "QuoteCell.h"
#import "Lesson.h"

@implementation QuoteCell

@synthesize characterLabel, subLabel, actAndSceneLabel, lesson;


- (void)setLesson:(Lesson *)newLesson {
 
    if (lesson != newLesson) {
        lesson = newLesson;
        
        characterLabel.text = lesson.topic;
        actAndSceneLabel.text = [NSString stringWithFormat:@"%d of %d", 1, 1];
        subLabel.text = lesson.lessonName;
    }
}



@end

