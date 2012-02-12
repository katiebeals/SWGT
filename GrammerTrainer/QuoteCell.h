
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

@property (nonatomic, weak) IBOutlet UILabel *characterLabel;
@property (nonatomic, weak) IBOutlet UILabel *actAndSceneLabel;
@property (nonatomic, weak) IBOutlet UILabel *subLabel;

@property (nonatomic, strong) Lesson *lesson;

@end
