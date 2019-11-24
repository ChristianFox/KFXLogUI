

/**********************************************************************
 *
 Copyright (c) 2016 Christian Fox <christianfox890@icloud.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 *
 **********************************************************************/





#import "KFXLogFileDetailVC.h"
// Frameworks
@import MessageUI;
// Pods
#import <KFXLog/KFXLog.h>

@interface KFXLogFileDetailVC () <MFMailComposeViewControllerDelegate, UISearchBarDelegate>

// Text
@property (strong,nonatomic) NSString *filePath;
@property (strong,nonatomic) NSMutableArray <NSValue*>*matchingRanges;
@property (nonatomic) NSUInteger selectedMatch;
// UI
@property (strong,nonatomic) UISearchBar *searchBar;
@property (strong,nonatomic) UIView *resultBar;
@property (strong,nonatomic) UITextView *textView;
@property (strong,nonatomic) UIButton *nextResultButton;
@property (strong,nonatomic) UIButton *previousResultButton;
@property (strong,nonatomic) UILabel *resultCountLabel;
@property (strong,nonatomic) NSLayoutConstraint *searchBarOriginY;

@end

@implementation KFXLogFileDetailVC




//======================================================
#pragma mark - ** Public Methods **
//======================================================
-(void)injectLogFilePath:(NSString *)filePath{
    self.filePath = filePath;
    if (self.textView != nil) {
        [self refreshTextViewText];
    }
}


//======================================================
#pragma mark - ** Inherited Methods **
//======================================================
//--------------------------------------------------------
#pragma mark - UIViewController
//--------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    [KFXLog logInfoWithSender:self format:@"Log File Viewer opened for log file at path: %@",self.filePath];
    [self addSubviews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

    // ## Display file log text ##
    if (self.filePath != nil) {
        [self refreshTextViewText];
    }

    [self addConstraintsForSubviews];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)addSubviews{
    
    
    // ## Add Search Bar ##
    self.searchBar = [[UISearchBar alloc]init];
    self.searchBar.delegate = self;
    self.searchBar.returnKeyType = UIReturnKeyDone;
    self.searchBar.showsCancelButton = YES;
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.searchBar];
    
    // ## Add Result Bar ##
    self.resultBar = [[UIView alloc]init];
    self.resultBar.backgroundColor = [UIColor lightGrayColor];
    self.resultBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.resultBar];
    // Buttons
    UIButton *nextResultButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextResultButton setTitle:@">" forState:UIControlStateNormal];
    [nextResultButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    nextResultButton.titleLabel.font = [UIFont systemFontOfSize:30.0 weight:UIFontWeightBold];
    nextResultButton.enabled = NO;
    nextResultButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.resultBar addSubview:nextResultButton];
    self.nextResultButton = nextResultButton;
    [self.nextResultButton addTarget:self
                              action:@selector(nextResultButtonTapped:)
                    forControlEvents:UIControlEventTouchUpInside];
    UIButton *previousResultButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [previousResultButton setTitle:@"<" forState:UIControlStateNormal];
    [previousResultButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    previousResultButton.titleLabel.font = [UIFont systemFontOfSize:30.0 weight:UIFontWeightBold];
    previousResultButton.enabled = NO;
    previousResultButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.resultBar addSubview:previousResultButton];
    self.previousResultButton = previousResultButton;
    [self.previousResultButton addTarget:self
                              action:@selector(previousResultButtonTapped:)
                    forControlEvents:UIControlEventTouchUpInside];

    // Label
    UILabel *resultCountLabel = [[UILabel alloc]init];
    resultCountLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
    resultCountLabel.textColor = [UIColor blackColor];
    resultCountLabel.text = @"Use the search bar to search the logs";
    resultCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.resultBar addSubview:resultCountLabel];
    self.resultCountLabel = resultCountLabel;

    // ## Add Text View ##
    self.textView = [[UITextView alloc]init];
    //    self.textView.textContainerInset = UIEdgeInsetsMake(50.0, 0.0, 0.0, 0.0);
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.editable = NO;
    self.textView.selectable = YES;
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.textView];
    
    // ## Add Navigation Bar buttons ##
    if (self.navigationController.navigationBar != nil) {
        // ## Add Bar Buttons ##
        UIBarButtonItem *emailButton = [[UIBarButtonItem alloc]initWithTitle:@"Email" style:UIBarButtonItemStylePlain target:self action:@selector(emailButtonTapped:)];
        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonTapped:)];
        UIBarButtonItem *jumpToEndButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(jumpToBottomButtonTapped:)];
        UIBarButtonItem *jumpToStartButton  = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(jumpToTopButtonTapped:)];;
        
        self.navigationItem.rightBarButtonItems = @[emailButton,refreshButton,jumpToEndButton,jumpToStartButton];
    }

}

-(void)addConstraintsForSubviews{
    
    NSDictionary *viewsDict = @{
                                @"searchBar":self.searchBar,
                                @"resultBar":self.resultBar,
                                @"textView":self.textView,
                                @"resultLabel":self.resultCountLabel,
                                @"prevButton":self.previousResultButton,
                                @"nextButton":self.nextResultButton
                                };
    CGFloat searchBarOriginY = 0.0;
    if (self.navigationController.navigationBar != nil) {
        searchBarOriginY += self.navigationController.navigationBar.bounds.size.height;
    }
    if (![UIApplication sharedApplication].isStatusBarHidden) {
        searchBarOriginY += 20.0;
    }
    NSDictionary *metrics = @{
                              @"searchBarY":@(searchBarOriginY),
                              @"labelHeight":@(30)
                              };
    
    // ## Horizontal ##
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[searchBar]|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:viewsDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[resultBar]|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:viewsDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textView]|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:viewsDict]];
    [self.resultBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[resultLabel]-[prevButton][nextButton]-|"
                                                                           options:kNilOptions
                                                                           metrics:metrics
                                                                             views:viewsDict]];
    
    // ## Vertical ##
    self.searchBarOriginY = [NSLayoutConstraint constraintWithItem:self.searchBar
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:searchBarOriginY];
    [self.view addConstraint:self.searchBarOriginY];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[searchBar(50)][resultBar(45)][textView]|"
                                                                      options:kNilOptions
                                                                      metrics:metrics
                                                                        views:viewsDict]];
    [self.resultBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[resultLabel]|"
                                                                      options:kNilOptions
                                                                      metrics:metrics
                                                                        views:viewsDict]];
    [self.resultBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[prevButton]|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:viewsDict]];
    [self.resultBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nextButton]|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:viewsDict]];
}

-(void)updateViewConstraints{

    /*
     Update the constraint for the search bar origin Y based on if there is a status bar and navigation bar visible - keep search bar flush to the top subview
    */
    CGFloat searchBarOriginY = 0.0;
    if (self.navigationController.navigationBar != nil) {
        searchBarOriginY += self.navigationController.navigationBar.bounds.size.height;
    }
    if (![UIApplication sharedApplication].isStatusBarHidden) {
        searchBarOriginY += 20.0;
    }
    self.searchBarOriginY.constant = searchBarOriginY;
    
    [super updateViewConstraints];
}



//--------------------------------------------------------
#pragma mark - Actions
//--------------------------------------------------------
-(void)emailButtonTapped:(id)sender{
    
    [KFXLog logUIEventWithSender:self format:@"-emailButtonTapped:"];
    if (![MFMailComposeViewController canSendMail]) {
        [KFXLog logFail:@"Cannot send mail from this device"];
        return;
    }
    
    
    NSString *subject = [self.filePath lastPathComponent];
    
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc]init];
    [mailVC setMailComposeDelegate:self];
    [mailVC setSubject:subject];
    NSData *data = [[NSFileManager defaultManager]contentsAtPath:self.filePath];
    if (data == nil) {
        [mailVC setMessageBody:self.textView.text isHTML:NO];
    }else{
        
        [mailVC addAttachmentData:data
                         mimeType:@"text/plain"
                         fileName:[self.filePath lastPathComponent]];
    }
    [self presentViewController:mailVC animated:YES completion:NULL];
}

-(void)refreshButtonTapped:(id)sender{
    [KFXLog logUIEventWithSender:self format:@"-refreshButtonTapped: *-*-*-*-*-*-*-*-*-*:"];

    [self refreshTextViewText];
    
}

-(void)jumpToTopButtonTapped:(id)sender{
    [self.textView scrollRangeToVisible:NSMakeRange(0, 0)];
}

-(void)jumpToBottomButtonTapped:(id)sender{
    [self.textView scrollRangeToVisible:NSMakeRange([self.textView.text length], 0)];
    
}

-(void)previousResultButtonTapped:(UIButton*)sender{

    if (self.selectedMatch >= 1) {
        
        NSMutableAttributedString *mutAttString = [self.textView.attributedText mutableCopy];
        
        // Reset the previously selected match
        NSValue *oldValue = self.matchingRanges[self.selectedMatch];
        NSRange oldRange = [oldValue rangeValue];
        [self highlightRange:oldRange ofAttributedString:mutAttString withColour:[UIColor greenColor]];

        // update
        self.selectedMatch--;
        
        // Highlight new selected match
        NSValue *newValue = self.matchingRanges[self.selectedMatch];
        NSRange newRange = [newValue rangeValue];
        [self highlightRange:newRange ofAttributedString:mutAttString withColour:[UIColor purpleColor]];
        
        // update label
        [self updateResultCountLabel];
        
        // Update text view
        self.textView.attributedText = [mutAttString copy];
        [self scrollTextViewToTextInRange:newRange];
    }
}

-(void)nextResultButtonTapped:(UIButton*)sender{
    
    if (self.selectedMatch+1 < self.matchingRanges.count) {
        
        NSMutableAttributedString *mutAttString = [self.textView.attributedText mutableCopy];
        
        // Reset the previously selected match
        NSValue *oldValue = self.matchingRanges[self.selectedMatch];
        NSRange oldRange = [oldValue rangeValue];
        [self highlightRange:oldRange ofAttributedString:mutAttString withColour:[UIColor greenColor]];
        
        // update
        self.selectedMatch++;
        
        // Highlight new selected match
        NSValue *newValue = self.matchingRanges[self.selectedMatch];
        NSRange newRange = [newValue rangeValue];
        [self highlightRange:newRange ofAttributedString:mutAttString withColour:[UIColor purpleColor]];
        
        // update label
        [self updateResultCountLabel];
        
        // Update text view
        self.textView.attributedText = [mutAttString copy];
        [self scrollTextViewToTextInRange:newRange];
    }
}

-(void)scrollTextViewToTextInRange:(NSRange)range{

    [self.textView setSelectedRange:range];
    
    CGRect textRect = [self.textView firstRectForRange:self.textView.selectedTextRange];
    [KFXLog logInfo:@"TextRect: %@",NSStringFromCGRect(textRect)];
    if (!CGRectContainsRect(self.textView.bounds, textRect)) {
        [self.textView scrollRectToVisible:textRect
                                  animated:YES];

    }
    
    [self.textView setSelectedRange:NSMakeRange(0, 0)];
    }

//======================================================
#pragma mark - ** Protocol Methods **
//======================================================
//--------------------------------------------------------
#pragma mark - MFMailComposeViewControllerDelegate
//--------------------------------------------------------
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MFMailComposeResultSent:
            [KFXLog logInfoWithSender:self format:@"Email log file: Sent"];
            break;
        case MFMailComposeResultSaved:
            [KFXLog logInfoWithSender:self format:@"Email log file: Saved"];
            break;
        case MFMailComposeResultFailed:
            [KFXLog logInfoWithSender:self format:@"Email log file: Failed"];
            break;
        case MFMailComposeResultCancelled:
            [KFXLog logInfoWithSender:self format:@"Email log file: Cancelled"];
            break;
            
        default:
            break;
    }
    
    if (error != nil) {
        [KFXLog logError:error sender:self];
    }
}


//--------------------------------------------------------
#pragma mark - UISearchBarDelegate
//--------------------------------------------------------
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self highlightInstancesOfString:searchText];
    [self updateResultCountLabel];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = nil;
    [self highlightInstancesOfString:@""];
    [self updateResultCountLabel];
    [searchBar resignFirstResponder];
}


-(void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [self.view setNeedsUpdateConstraints];
}

//======================================================
#pragma mark - ** Private Methods **
//======================================================
-(void)refreshTextViewText{
    NSAttributedString *attString = [[NSAttributedString alloc]initWithString:[self textFromFileAtPath:self.filePath]
                                                                   attributes:nil];
    
    self.textView.attributedText = attString;
}


-(NSString*)textFromFileAtPath:(NSString*)filePath{
    
    NSString *logText;
    NSFileManager *fileMan = [NSFileManager defaultManager];
    if ([fileMan fileExistsAtPath:filePath]) {
        
        NSError *error;
        logText = [[NSString alloc]initWithContentsOfFile:filePath
                                                 encoding:NSUTF8StringEncoding
                                                    error:&error];
        if (logText == nil) {
            [KFXLog logFail:@"Failed to get text from log file at path: %@",filePath];
            if (error) {
                [KFXLog logError:error sender:self];
            }
        }
    }
    return logText;
    
}


-(void)highlightInstancesOfString:(NSString*)needle{
    
    // Clear old highlights first
    NSMutableAttributedString *mutAttString = [self.textView.attributedText mutableCopy];
    [mutAttString removeAttribute:NSBackgroundColorAttributeName range:NSMakeRange(0, mutAttString.length)];
    self.textView.attributedText = [mutAttString copy];
    
    // Clear previous matches
    [self.matchingRanges removeAllObjects];
    self.selectedMatch = 0;
    
    NSString *haystack = self.textView.attributedText.string;

    // From: http://stackoverflow.com/questions/7033574/find-all-locations-of-substring-in-nsstring-not-just-first
    
    NSRange searchRange = NSMakeRange(0,haystack.length);
    NSRange foundRange;
    while (searchRange.location < haystack.length) {
        searchRange.length = haystack.length-searchRange.location;
        foundRange = [haystack rangeOfString:needle options:NSCaseInsensitiveSearch range:searchRange];
        if (foundRange.location != NSNotFound) {
            // found an occurrence of the substring! do stuff here
            searchRange.location = foundRange.location+foundRange.length;
            [self highlightRange:foundRange ofAttributedString:mutAttString withColour:[UIColor greenColor]];
            [self.matchingRanges addObject:[NSValue valueWithRange:foundRange]];
        } else {
            // no more substring to find
            self.textView.attributedText = [mutAttString copy];
            break;
        }
    }
    if (self.matchingRanges.count >= 1) {
        self.previousResultButton.enabled = YES;
        self.nextResultButton.enabled = YES;
    }else{
        self.previousResultButton.enabled = NO;
        self.nextResultButton.enabled = NO;
    }
}

-(void)highlightRange:(NSRange)range ofAttributedString:(NSMutableAttributedString*)mutAttString withColour:(UIColor*)colour{
    
    [mutAttString beginEditing];
    [mutAttString addAttribute:NSBackgroundColorAttributeName
                         value:colour
                         range:range];
    [mutAttString endEditing];

}


-(void)updateResultCountLabel{
    
    NSUInteger selectedMatch = self.selectedMatch;
    NSUInteger matchesCount = self.matchingRanges.count;
    if (matchesCount == 0) {
        selectedMatch = 0;
    }else{
        selectedMatch++;
    }
    
    self.resultCountLabel.text = [NSString stringWithFormat:@"%lu of %lu matches",(unsigned long)selectedMatch,(unsigned long)matchesCount];
}

//--------------------------------------------------------
#pragma mark - Lazy Load
//--------------------------------------------------------
-(NSMutableArray <NSValue*>*)matchingRanges{
    if (!_matchingRanges) {
        _matchingRanges = [NSMutableArray arrayWithCapacity:100];
    }
    return _matchingRanges;
}




//======================================================
#pragma mark - ** Navigation **
//======================================================
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}



@end
