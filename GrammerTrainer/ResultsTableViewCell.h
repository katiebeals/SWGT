//
//  ResultsTableViewCell.h
//  CreativityApp
//
//  Created by Eric Kille on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UACellBackgroundView.h"


@interface ResultsTableViewCell : UITableViewCell {

	UIProgressView *progressView;
	UILabel *descriptionOne;
	UILabel *descriptionTwo;
	UILabel *greenCount;
	UILabel *redCount;
    UIImageView *checkMark;

	UILabel *scoreLabel;

}

- (void)setPosition:(UACellBackgroundViewPosition)newPosition;
- (void)setColor:(UACellBackgroundColor)newColor;

@property (nonatomic, retain) IBOutlet UIImageView *checkMark;
@property (nonatomic, retain) IBOutlet UIProgressView *progressView;
@property (nonatomic, retain) IBOutlet UILabel *descriptionOne;
@property (nonatomic, retain) IBOutlet UILabel *descriptionTwo;
@property (nonatomic, retain) IBOutlet UILabel *greenCount;
@property (nonatomic, retain) IBOutlet UILabel *redCount;

@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;

@end
