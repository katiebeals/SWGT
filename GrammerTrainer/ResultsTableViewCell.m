//
//  ResultsTableViewCell.m
//  CreativityApp
//
//  Created by Eric Kille on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ResultsTableViewCell.h"

@implementation ResultsTableViewCell

@synthesize progressView, descriptionOne, descriptionTwo, redCount, greenCount, checkMark, scoreLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier]) {
		
        // Background Image
        self.backgroundView = [[UACellBackgroundView alloc] initWithFrame:CGRectZero];
    }
    return self;	
}


- (void)setPosition:(UACellBackgroundViewPosition)newPosition {	
    [(UACellBackgroundView *)self.backgroundView setPosition:newPosition];
}

- (void)setColor:(UACellBackgroundColor)newColor {
	[(UACellBackgroundView *)self.backgroundView setColor:newColor]; 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
