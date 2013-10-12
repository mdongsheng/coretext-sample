//
//  CoreTextView.h
//  CoreTextTests
//
//  Created by 东升 on 13-9-18.
//  Copyright (c) 2013年 东升. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface CoreTextView : UIView {
    CTFrameRef ctFrame;
    CTFramesetterRef framesetter;
    NSMutableAttributedString *text;
    CGPoint imageLocation;
    UIImage *image;
}

- (void) initText;

@end
