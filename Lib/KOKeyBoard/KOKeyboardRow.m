//
//  ExtraKeyboardRow.m
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

#import "KOKeyboardRow.h"
#import "KOSwipeButton.h"

@interface KOKeyboardRow ()

@property(nonatomic, retain) UITextView *textView;
@property(nonatomic, assign) CGRect startLocation;

@end

@implementation KOKeyboardRow

@synthesize textView, startLocation;

+ (void)applyToTextView:(UITextView *) t {
    int barHeight = 44;
    int barWidth = 320;

    KOKeyboardRow *v = [[KOKeyboardRow alloc] initWithFrame:CGRectMake(0, 0, barWidth, barHeight)];
    v.backgroundColor = [UIColor colorWithRed:156 / 255. green:155 / 255. blue:166 / 255. alpha:1.];
    v.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    v.textView = t;

    UIView *border1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, barWidth, 1)];
    border1.backgroundColor = [UIColor colorWithRed:51 / 255. green:51 / 255. blue:51 / 255. alpha:1.];
    border1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [v addSubview:border1];

    UIView *border2 = [[UIView alloc] initWithFrame:CGRectMake(0, 1, barWidth, 1)];
    border2.backgroundColor = [UIColor colorWithRed:191 / 255. green:191 / 255. blue:191 / 255. alpha:1.];
    border2.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [v addSubview:border2];

    int buttonHeight = 40;
    int leftMargin = 1;
    int topMargin = 1;
    int buttonSpacing = 1;


    NSArray *keys = @[
        @"TTTTT",
        @"()-[]",
        @"<>*#+",
        @"◉◉◉◉◉",
        @"'\"`_.",
        @"UUUUU",
        @"RRRRR"
    ];

    int buttonCount = [keys count];
    int buttonWidth = (barWidth - 2 * leftMargin - (buttonCount - 1) * buttonSpacing) / buttonCount;
    leftMargin = (barWidth - buttonWidth * buttonCount - buttonSpacing * (buttonCount - 1)) / 2;
    for (NSUInteger i = 0; i < buttonCount; i++) {
        KOSwipeButton *b = [[KOSwipeButton alloc] initWithFrame:CGRectMake(
            leftMargin + i * (buttonSpacing + buttonWidth),
            topMargin + (barHeight - buttonHeight) / 2, buttonWidth, buttonHeight)];
        b.keys = [self splitByCharacter:keys[i]];
        b.delegate = v;
        b.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [v addSubview:b];
    }

    t.inputAccessoryView = v;
}

+ (NSArray *)splitByCharacter:(NSString *) str {
    NSMutableArray *array = [NSMutableArray array];
    unichar unicodeChar;
    NSString *rune;
    for (int i = 0; i < str.length; ++i) {
        unicodeChar = [str characterAtIndex:i];

        if (unicodeChar >= 0xD800 && unicodeChar <= 0xDBFF) {
            rune = [str substringWithRange:NSMakeRange(i, 2)];
            ++i;
        } else {
            rune = [str substringWithRange:NSMakeRange(i, 1)];
        }
        [array addObject:rune];
    }
    NSAssert([array count] <= 5, @"Max is 5");
    return array;
}

- (void)insertText:(NSString *) text {
    if (textView.delegate && [textView.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        if ([textView.delegate textView:textView
                               shouldChangeTextInRange:textView.selectedRange
                               replacementText:text]) {
            [textView insertText:text];
        }
    } else {
        [textView insertText:text];
    }
}

- (void)trackPointStarted {
    startLocation = [textView caretRectForPosition:textView.selectedTextRange.start];
}

- (void)undoAction {
    [[textView undoManager] undo];
}

- (void)redoAction {
    [[textView undoManager] redo];
}


- (void)trackPointMovedX:(int) xdiff Y:(int) ydiff selecting:(BOOL) selecting {
    CGRect loc = startLocation;

    loc.origin.y -= textView.contentOffset.y;

    UITextPosition *p1 = [textView closestPositionToPoint:loc.origin];

    loc.origin.x -= xdiff;
    loc.origin.y -= ydiff;

    UITextPosition *p2 = [textView closestPositionToPoint:loc.origin];

    if (!selecting) {
        p1 = p2;
    }
    UITextRange *r = [textView textRangeFromPosition:p1 toPosition:p2];

    textView.selectedTextRange = r;
}

@end
