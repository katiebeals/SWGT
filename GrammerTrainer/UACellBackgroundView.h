
#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

typedef enum  {
    UACellBackgroundViewPositionSingle = 0,
    UACellBackgroundViewPositionTop, 
    UACellBackgroundViewPositionBottom,
    UACellBackgroundViewPositionMiddle
} UACellBackgroundViewPosition;

typedef enum  {
    UACellBackgroundLightGray = 0,
    UACellBackgroundDarkGray
} UACellBackgroundColor;

@interface UACellBackgroundView : UIView {
    UACellBackgroundViewPosition position;
	UACellBackgroundColor color;
}

@property(nonatomic) UACellBackgroundColor color;
@property(nonatomic) UACellBackgroundViewPosition position;

@end
