
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


#import "KFXLogFileTVCell.h"



@implementation KFXLogFileTVCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self sharedInitilisation];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self sharedInitilisation];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self sharedInitilisation];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        [self sharedInitilisation];
    }
    return self;
}


-(void)sharedInitilisation{
    
    self.fileNameLabel = [[UILabel alloc]init];
    self.creationDateLabel = [[UILabel alloc]init];
    self.modificationDateLabel = [[UILabel alloc]init];
    self.fileNameLabel.minimumScaleFactor = 0.5;
    self.creationDateLabel.minimumScaleFactor = 0.5;
    self.modificationDateLabel.minimumScaleFactor = 0.5;
    self.fileNameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.creationDateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.modificationDateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
    self.fileNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.creationDateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.modificationDateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.fileNameLabel];
    [self.contentView addSubview:self.creationDateLabel];
    [self.contentView addSubview:self.modificationDateLabel];

    [self layoutLabels];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)layoutLabels{
    
    NSDictionary *viewsDict = @{
                                @"nameLabel":self.fileNameLabel,
                                @"creationLabel":self.creationDateLabel,
                                @"modificationLabel":self.modificationDateLabel
                                };
    NSDictionary *metrics = @{
                              @"leftMargin":@20.0,
                              @"rightMargin":@20.0,
                              @"verticalMargin":@4.0,
                              @"labelHeight":@22
                              };
    
    //                          @"V:|-verticalMargin-[nameLabel(labelHeight)]-20-[creationLabel(labelHeight)]-20-[modificationLabel(labelHeight)]-verticalMargin-|"

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                          @"V:|-verticalMargin-[nameLabel(labelHeight)][creationLabel(labelHeight)][modificationLabel(labelHeight)]-verticalMargin-|"
                                                                 options:kNilOptions
                                                                 metrics:metrics
                                                                   views:viewsDict]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.fileNameLabel
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.contentView
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0
                                                      constant:[metrics[@"leftMargin"] doubleValue]]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.creationDateLabel
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.contentView
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0
                                                      constant:[metrics[@"leftMargin"] doubleValue]]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.modificationDateLabel
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.contentView
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0
                                                      constant:[metrics[@"leftMargin"] doubleValue]]];

}



-(void)prepareForReuse{
    [super prepareForReuse];
}



@end
