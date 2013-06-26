
/*
     File: QuoteCell.h
 Abstract: Table view cell to display information about a news item.
 The cell is configured in QuoteCell.xib.
 
  Version: 2.0
  
 Copyright (C) 2011 Apple Inc. All Rights Reserved.
 
 */

@class HighlightingTextView;
@class Lesson;


@interface QuoteCell : UITableViewCell 

@property (assign) IBOutlet UILabel *characterLabel;
@property (assign) IBOutlet UILabel *actAndSceneLabel;
@property (assign) IBOutlet UILabel *subLabel;

@property (nonatomic, strong) Lesson *lesson;

@end
