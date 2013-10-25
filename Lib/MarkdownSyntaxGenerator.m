//
// Created by azu on 2013/10/26.
//


#import "MarkdownSyntaxGenerator.h"


#define regexp(reg,option) [NSRegularExpression regularExpressionWithPattern:@reg options:option error:NULL]

NSRegularExpression *NSRegularExpressionFromMarkdownSyntaxType(MarkdownSyntaxType v) {
    switch (v) {
        case MarkdownSyntaxUnknown:
            return nil;
        case MarkdownSyntaxHeaders:
            return regexp("(#+)(.*)", 0);
        case MarkdownSyntaxLinks:
            return regexp("\\[([^\\[]+)\\]\\(([^\\)]+)\\)", 0);
        case MarkdownSyntaxBold:
            return regexp("\\*\\*|__)(.*?)\\1", 0);
        case MarkdownSyntaxEmphasis:
            return regexp("\\s(\\*|_)(.*?)\\1\\s", 0);
        case MarkdownSyntaxDeletions:
            return regexp("\\~\\~(.*?)\\~\\~", 0);
        case MarkdownSyntaxQuotes:
            return regexp("\\:\\\"(.*?)\\\"\\:", 0);
        case MarkdownSyntaxInlineCode:
            return regexp("`(.*?)`", 0);
        case MarkdownSyntaxCodeBlock:
            return regexp("```([\\s\\S]*?)```", 0);
        case MarkdownSyntaxBlockquotes:
            return regexp("\\n(&gt;|\\>)(.*)", 0);
        case MarkdownSyntaxULLists:
            return regexp("\\n\\*([^\\*]*)", 0);
        case MarkdownSyntaxOLLists:
            return regexp("\\n[0-9]+\\.(.*)", 0);
    }
    return nil;
}

NSDictionary *AttributesFromMarkdownSyntaxType(MarkdownSyntaxType v) {
    switch (v) {
        case MarkdownSyntaxUnknown:
            return @{};
        case MarkdownSyntaxHeaders:
            return @{
                NSFontAttributeName : [UIFont boldSystemFontOfSize:16]
            };
        case MarkdownSyntaxLinks:
            return @{NSForegroundColorAttributeName : [UIColor blueColor]};
        case MarkdownSyntaxBold:
            return @{NSFontAttributeName : [UIFont boldSystemFontOfSize:14]};
        case MarkdownSyntaxEmphasis:
            return @{NSFontAttributeName : [UIFont boldSystemFontOfSize:14]};
        case MarkdownSyntaxDeletions:
            return @{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle)};
        case MarkdownSyntaxQuotes:
            return @{NSForegroundColorAttributeName : [UIColor lightGrayColor]};
        case MarkdownSyntaxInlineCode:
            return @{NSForegroundColorAttributeName : [UIColor brownColor]};
        case MarkdownSyntaxCodeBlock:
            return @{
                NSBackgroundColorAttributeName : [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0]
            };
        case MarkdownSyntaxBlockquotes:
            return @{NSBackgroundColorAttributeName : [UIColor lightGrayColor]};
        case MarkdownSyntaxULLists:
            return @{};
        case MarkdownSyntaxOLLists:
            return @{};
    }
    return nil;
}


@implementation MarkdownSyntaxGenerator {

}
- (NSArray *)syntaxModelsForText:(NSString *) text {
    NSMutableArray *markdownSyntaxModels = [NSMutableArray array];
    NSArray *syntaxArray = @[
        @(MarkdownSyntaxUnknown),
        @(MarkdownSyntaxHeaders),
        @(MarkdownSyntaxLinks),
        @(MarkdownSyntaxBold),
        @(MarkdownSyntaxEmphasis),
        @(MarkdownSyntaxDeletions),
        @(MarkdownSyntaxQuotes),
        @(MarkdownSyntaxInlineCode),
        @(MarkdownSyntaxCodeBlock),
        @(MarkdownSyntaxBlockquotes),
        @(MarkdownSyntaxULLists),
        @(MarkdownSyntaxOLLists),
    ];
    for (NSNumber *number in syntaxArray) {
        MarkdownSyntaxType type = (MarkdownSyntaxType)[number unsignedIntegerValue];
        NSRegularExpression *expression = NSRegularExpressionFromMarkdownSyntaxType(type);
        NSArray *matches = [expression matchesInString:text
                                       options:0
                                       range:NSMakeRange(0, [text length])];
        for (NSTextCheckingResult *result in matches) {
            [markdownSyntaxModels addObject:[MarkdownSyntaxModel modelWithType:type range:result.range]];
        }
    }
    return markdownSyntaxModels;
}
@end