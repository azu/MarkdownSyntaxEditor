//
// Created by azu on 2013/10/26.
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MarkdownSyntaxType){
    MarkdownSyntaxUnknown,
    MarkdownSyntaxHeaders,
    MarkdownSyntaxLinks,
    MarkdownSyntaxBold,
    MarkdownSyntaxEmphasis,
    MarkdownSyntaxDeletions,
    MarkdownSyntaxQuotes,
    MarkdownSyntaxInlineCode,
    MarkdownSyntaxCodeBlock,
    MarkdownSyntaxBlockquotes,
    MarkdownSyntaxULLists,
    MarkdownSyntaxOLLists,
    NumberOfMarkdownSyntax,
};

@interface MarkdownSyntaxModel : NSObject
@property(nonatomic) NSRange range;
@property(nonatomic) MarkdownSyntaxType type;

- (instancetype)initWithType:(enum MarkdownSyntaxType) type range:(NSRange) range;

+ (instancetype)modelWithType:(enum MarkdownSyntaxType) type range:(NSRange) range;

@end