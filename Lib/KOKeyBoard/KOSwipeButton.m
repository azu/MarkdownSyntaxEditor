//
//  SwipeButton.m
//  KeyboardTest
//
//  Created by Kuba on 28.06.12.
//  Copyright (c) 2012 Adam Horacek, Kuba Brecka
//
//  Website: http://www.becomekodiak.com/
//  github: http://github.com/adamhoracek/KOKeyboard
//	Twitter: http://twitter.com/becomekodiak
//  Mail: adam@becomekodiak.com, kuba@becomekodiak.com
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "KOSwipeButton.h"
#import "KOKeyboardRow.h"

@interface KOSwipeButton ()

@property(nonatomic, retain) NSMutableArray *labels;
@property(nonatomic, assign) CGPoint touchBeginPoint;
@property(nonatomic, retain) UILabel *selectedLabel;
@property(nonatomic, retain) UIImageView *bgView;
@property(nonatomic, retain) UIImageView *foregroundView;
@property(nonatomic, retain) NSDate *firstTapDate;
@property(nonatomic, assign) BOOL selecting;
@property(nonatomic, retain) UIImage *blueImage;
@property(nonatomic, retain) UIImage *pressedImage;
@property(nonatomic, retain) UIImage *blueFgImage;
@property(nonatomic, retain) UIImage *pressedFgImage;

@property(nonatomic, strong) UILabel *leftTopLabel;
@property(nonatomic, strong) UILabel *rightTopLabel;
@property(nonatomic, strong) UILabel *centerLabel;
@property(nonatomic, strong) UILabel *leftBottomLabel;
@property(nonatomic, strong) UILabel *rightBottomLabel;
@end

#define TIME_INTERVAL_FOR_DOUBLE_TAP 0.4

@implementation KOSwipeButton

@synthesize labels, touchBeginPoint, selectedLabel, delegate, bgView, selecting, firstTapDate, blueImage, pressedImage, foregroundView, blueFgImage, pressedFgImage;

- (void)setFrame:(CGRect) frame {
    [super setFrame:frame];
}

- (id)initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];

    UIImage *bgImg1 = [[UIImage imageNamed:@"key.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(
        9, 9, 9, 9)];
    UIImage *bgImg2 = [[UIImage imageNamed:@"key-pressed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(
        9, 9, 9, 9)];
    bgView = [[UIImageView alloc] initWithFrame:self.bounds];
    [bgView setImage:bgImg1];
    [bgView setHighlightedImage:bgImg2];
    bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:bgView];

    CGFloat labelWidth = 8;
    CGFloat labelHeight = 15;
    CGFloat leftInset = 9;
    CGFloat rightInset = 9;
    CGFloat topInset = 3;
    CGFloat bottomInset = 8;

    self.labels = [[NSMutableArray alloc] init];

    UIFont *font = [UIFont systemFontOfSize:[self labelFontSize]];

    self.leftTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftInset, topInset, labelWidth,
        labelHeight)];
    self.leftTopLabel.textAlignment = NSTextAlignmentLeft;
    self.leftTopLabel.hidden = YES;
    self.leftTopLabel.text = @"↖";
    self.leftTopLabel.font = font;
    [self addSubview:self.leftTopLabel];
    [self.leftTopLabel setHighlightedTextColor:[UIColor blueColor]];
    self.leftTopLabel.backgroundColor = [UIColor clearColor];
    [labels addObject:self.leftTopLabel];

    self.rightTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(
        self.frame.size.width - labelWidth - rightInset,
        topInset, labelWidth, labelHeight)];
    self.rightTopLabel.textAlignment = NSTextAlignmentRight;
    self.rightTopLabel.hidden = YES;
    self.rightTopLabel.text = @"↗";
    self.rightTopLabel.font = font;
    self.rightTopLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self addSubview:self.rightTopLabel];
    [self.rightTopLabel setHighlightedTextColor:[UIColor blueColor]];
    self.rightTopLabel.backgroundColor = [UIColor clearColor];
    [labels addObject:self.rightTopLabel];

    self.centerLabel = [[UILabel alloc] initWithFrame:CGRectIntegral(
        CGRectMake((self.frame.size.width - labelWidth - leftInset - rightInset) / 2 + leftInset,
            (self.frame.size.height - labelHeight - topInset - bottomInset) / 2 + topInset,
            labelWidth, labelHeight))];
    self.centerLabel.textAlignment = NSTextAlignmentCenter;
    self.centerLabel.hidden = YES;
    self.centerLabel.text = @"Center";
    self.centerLabel.font = font;
    self.centerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.centerLabel];
    [self.centerLabel setHighlightedTextColor:[UIColor blueColor]];
    self.centerLabel.backgroundColor = [UIColor clearColor];
    [labels addObject:self.centerLabel];

    self.leftBottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftInset,
        (self.frame.size.height - labelHeight - bottomInset), labelWidth, labelHeight)];
    self.leftBottomLabel.textAlignment = NSTextAlignmentLeft;
    self.leftBottomLabel.hidden = YES;
    self.leftBottomLabel.text = @"↙";
    self.leftBottomLabel.font = font;
    [self addSubview:self.leftBottomLabel];
    [self.leftBottomLabel setHighlightedTextColor:[UIColor blueColor]];
    self.leftBottomLabel.backgroundColor = [UIColor clearColor];
    [labels addObject:self.leftBottomLabel];


    self.rightBottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(
        self.frame.size.width - labelWidth - rightInset,
        (self.frame.size.height - labelHeight - bottomInset), labelWidth, labelHeight)];
    self.rightBottomLabel.textAlignment = NSTextAlignmentRight;
    self.rightBottomLabel.hidden = YES;
    self.rightBottomLabel.text = @"↘";
    self.rightBottomLabel.font = font;
    self.rightBottomLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self addSubview:self.rightBottomLabel];
    [self.rightBottomLabel setHighlightedTextColor:[UIColor blueColor]];
    self.rightBottomLabel.backgroundColor = [UIColor clearColor];
    [labels addObject:self.rightBottomLabel];

    firstTapDate = [NSDate distantPast];

    return self;
}

- (void)setKeys:(NSArray *) newKeys {
    _keys = newKeys;
    [self updateLabels:newKeys];
}

- (void)updateLabels:(NSArray *) newKeys {
    if ([self isTabButton]) {
        [self.centerLabel setHidden:NO];
        [self.centerLabel setText:@"TAB"];
        [self.centerLabel setFrame:self.bounds];
        return;
    } else if ([self isTrackPoint]) {
        [self insertImage:@"trackpoint"];
        return;
    } else if ([self isUndoButton]) {
        [self insertImage:@"undo"];
        return;
    } else if ([self isRedoButton]) {
        [self insertImage:@"redo"];
        return;
    } else {
        for (int i = 0; i < [newKeys count]; i++) {
            UILabel *label = [labels objectAtIndex:i];
            label.hidden = NO;
            [label setText:newKeys[i]];
        }
    }

}

- (void)insertImage:(NSString *) buttonName {
    blueImage = [UIImage imageNamed:@"key-blue.png"];
    pressedImage = [UIImage imageNamed:@"key-pressed.png"];
    UIImage *bgImg1 = [UIImage imageNamed:[NSString stringWithFormat:@"%@-black.png", buttonName]];
    UIImage *bgImg2 = [UIImage imageNamed:[NSString stringWithFormat:@"%@-blue.png", buttonName]];
    blueFgImage = [UIImage imageNamed:@"trackpoint-white.png"];
    pressedFgImage = bgImg2;
    CGFloat imageSize = 8;
    foregroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,
        imageSize, imageSize)];
    foregroundView.frame = CGRectMake(
        (int)((self.frame.size.width - foregroundView.frame.size.width) / 2),
        (int)((self.frame.size.height - foregroundView.frame.size.height) / 2),
        imageSize, imageSize);
    [foregroundView setImage:bgImg1];
    [foregroundView setHighlightedImage:bgImg2];
    foregroundView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:foregroundView];
}

- (BOOL)isTabButton {
    return [self.keys containsObject:@"T"];
}

- (BOOL)isTrackPoint {
    return [self.keys containsObject:@"◉"];
}

- (BOOL)isUndoButton {
    return [self.keys containsObject:@"U"];
}

- (BOOL)isRedoButton {
    return [self.keys containsObject:@"R"];
}

- (CGFloat)labelFontSize {
    return 13.0f;
}

- (void)selectLabel:(int) idx {
    selectedLabel = nil;
    for (int i = 0; i < labels.count; i++) {
        UILabel *label = [labels objectAtIndex:i];
        label.highlighted = (idx == i);
        label.font = [UIFont systemFontOfSize:[self labelFontSize]];
        if (idx == i) {
            label.font = [UIFont boldSystemFontOfSize:[self labelFontSize]];
            selectedLabel = label;
        }
    }
    bgView.highlighted = selectedLabel != nil;
    foregroundView.highlighted = selectedLabel != nil;
}

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event {
    UITouch *t = [touches anyObject];
    touchBeginPoint = [t locationInView:self];

    if ([self isTrackPoint]) {
        if (fabs([firstTapDate timeIntervalSinceNow]) < TIME_INTERVAL_FOR_DOUBLE_TAP) {
            bgView.highlightedImage = blueImage;
            foregroundView.highlightedImage = blueFgImage;
            selecting = YES;
        } else {
            bgView.highlightedImage = pressedImage;
            foregroundView.highlightedImage = pressedFgImage;
            selecting = NO;
        }
        firstTapDate = [NSDate date];

        [delegate trackPointStarted];
    }

    [self selectLabel:2];
}

- (void)touchesMoved:(NSSet *) touches withEvent:(UIEvent *) event {
    UITouch *anyObject = [touches anyObject];
    CGPoint touchMovePoint = [anyObject locationInView:self];

    CGFloat xdiff = touchBeginPoint.x - touchMovePoint.x;
    CGFloat ydiff = touchBeginPoint.y - touchMovePoint.y;
    CGFloat distance = (CGFloat)sqrt(xdiff * xdiff + ydiff * ydiff);

    if ([self isTrackPoint]) {
        [delegate trackPointMovedX:xdiff Y:ydiff selecting:selecting];
        return;
    }
    if (distance > 250) {
        [self selectLabel:-1];
    } else if (![self isTabButton] && (distance > 20)) {
        CGFloat angle = (CGFloat)atan2(xdiff, ydiff);
        if (angle >= 0 && angle < M_PI_2) {
            [self selectLabel:0];
        } else if (angle >= 0 && angle >= M_PI_2) {
            [self selectLabel:3];
        } else if (angle < 0 && angle > -M_PI_2) {
            [self selectLabel:1];
        } else if (angle < 0 && angle <= -M_PI_2) {
            [self selectLabel:4];
        }
    } else {
        [self selectLabel:2];
    }
}

- (void)touchesEnded:(NSSet *) touches withEvent:(UIEvent *) event {
    if (selectedLabel != nil) {
        if ([self isTabButton]) {
            [delegate insertText:@"\t"];
        } else if ([self isTrackPoint]) {
            // noAction
        } else if ([self isUndoButton] || [selectedLabel.text isEqualToString:@"↩"]) {
            [self.delegate undoAction];
        } else if ([self isRedoButton] || [selectedLabel.text isEqualToString:@"↪"]) {
            [self.delegate redoAction];
        } else {
            [delegate insertText:selectedLabel.text];
        }
    }

    [self selectLabel:-1];
}


- (void)touchesCancelled:(NSSet *) touches withEvent:(UIEvent *) event {
    [self selectLabel:-1];
}

@end
