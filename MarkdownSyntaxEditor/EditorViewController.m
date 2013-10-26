//
// Created by azu on 2013/10/26.
//


#import "EditorViewController.h"
#import "MarkdownTextView.h"


@implementation EditorViewController {

    __weak IBOutlet MarkdownTextView *editorTextView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    editorTextView.contentInset = UIEdgeInsetsMake(0, 0,
        0, 0);
}


@end