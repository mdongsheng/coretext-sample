//
//  CoreTextView.m
//  CoreTextTests
//
//  Created by 东升 on 13-9-18.
//  Copyright (c) 2013年 东升. All rights reserved.
//

#import "CoreTextView.h"

const CGFloat IMG_ZERO_HEIGHT = 0.0f;
#define IMG_HEIGHT 200.0f
#define IMG_WIDTH 200.0f

static void deallocCallback(void *ref) {
    NSLog(@"release");
    [(id)ref release];
}

static CGFloat getAscent(void *ref) {
    return IMG_HEIGHT;//[[(NSDictionary*)ref valueForKey:@"height"] floatValue];
}

static CGFloat getDescent(void *ref) {
    return IMG_ZERO_HEIGHT;//[[(NSDictionary*)ref valueForKey:@"descent"] floatValue];
}

static CGFloat getWidth(void *ref) {
    return IMG_WIDTH;//[[(NSDictionary*)ref valueForKey:@"width"] floatValue];
}

@implementation CoreTextView

-(void)dealloc {
    [image release];
    image = nil;
    [text release];
    text = nil;
    CFRelease(ctFrame);
    CFRelease(framesetter);
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.layer.geometryFlipped = YES;
        image = [UIImage imageNamed:@"Textmate.png"];
    }
    return self;
}

- (void)initText {
    text = [[NSMutableAttributedString alloc] initWithString:@""];
    NSAttributedString *txt1 = [[NSAttributedString alloc] initWithString:@"测试"];
    [text appendAttributedString:txt1];
    
    [txt1 release];
    
    CTRunDelegateCallbacks callback;
    callback.version = kCTRunDelegateVersion1; //必须指定，否则不会生效，没有回调产生。
    callback.dealloc = deallocCallback;
    callback.getAscent = getAscent;
    callback.getDescent = getDescent;
    callback.getWidth = getWidth;
    NSDictionary *imgAttr = [[NSDictionary dictionaryWithObjectsAndKeys:@100, @"width", nil] retain];
    
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callback, imgAttr);
    NSDictionary *txtDelegate = [NSDictionary dictionaryWithObjectsAndKeys:(id)delegate, (NSString*)kCTRunDelegateAttributeName, @100, @"width", nil];
    NSAttributedString *imgField = [[[NSAttributedString alloc] initWithString:@" " attributes:txtDelegate] autorelease];
    [text appendAttributedString:imgField];
    
    [text appendAttributedString:[[[NSAttributedString alloc] initWithString: @"结束"] autorelease]];
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    
    framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)text);
    
    ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), pathRef, NULL);
    
    CFArrayRef lines = CTFrameGetLines(ctFrame);
    
    CGPoint origins[CFArrayGetCount(lines)];
    
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), origins);
    
    for (int i = 0; i < CFArrayGetCount(lines); i++) {
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        
        for (int j = 0; j < CFArrayGetCount(runs); j++) {
            
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            
            CGPoint lineOrigin = origins[i];
            
            NSDictionary *meta = (NSDictionary*)CTRunGetAttributes(run);
            
            if (meta && ([meta valueForKey:@"width"] != nil)) {
                imageLocation.y = lineOrigin.y;
                
                CGFloat offset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
                imageLocation.x = lineOrigin.x + offset + self.frame.origin.x;
            }
        }
        
    }
    
    CFRelease(pathRef);
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    CTFrameDraw(ctFrame, context);
    CGRect imgRect = CGRectMake(imageLocation.x, imageLocation.y, IMG_WIDTH, IMG_HEIGHT);
    //CGContextDrawImage(context, CGRectMake(imageLocation.x, imageLocation.y, 100.0, 100.0), [image CGImage]);
    //CGRect convertRect = [self convertRect:imgRect toView:nil];
    CGContextDrawImage(context, imgRect, [image CGImage]);
}

@end
