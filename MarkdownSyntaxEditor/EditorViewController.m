//
// Created by azu on 2013/10/26.
//


#import "EditorViewController.h"
#import "MarkdownSyntaxGenerator.h"


@implementation EditorViewController {

    __weak IBOutlet UITextView *editorTextView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateSyntaxTextView:editorTextView];
}

- (void)updateSyntaxTextView:(UITextView *) textView {
    MarkdownSyntaxGenerator *markdownSyntaxGenerator = [[MarkdownSyntaxGenerator alloc] init];
    textView.scrollEnabled = NO;
    NSRange selectedRange = textView.selectedRange;
    NSArray *models = [markdownSyntaxGenerator syntaxModelsForText:textView.text];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textView.text];
    for (MarkdownSyntaxModel *model in models) {
        [attributedString addAttributes:AttributesFromMarkdownSyntaxType(model.type) range:model.range];
    }
    textView.attributedText = attributedString;
    textView.selectedRange = selectedRange;
    textView.scrollEnabled = YES;
}

- (void)textViewDidChange:(UITextView *) textView {
    if (![textView isEqual:editorTextView]) {
        return;
    }
    [self updateSyntaxTextView:textView];
}

@end