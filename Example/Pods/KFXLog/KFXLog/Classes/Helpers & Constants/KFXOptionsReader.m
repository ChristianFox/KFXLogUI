
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


#import "KFXOptionsReader.h"
#import "KFXLogConfigurator.h"
// Descriptors
#import "KFXBasicLogDescriptor.h"
#import "KFXCleanLogDescriptor.h"
#import "KFXFileLogDescriptor.h"
#import "KFXAlertLogDescriptor.h"
#import "KFXServiceLogDescriptor.h"

@implementation KFXOptionsReader

//======================================================
#pragma mark - ** Public Methods **
//======================================================
//--------------------------------------------------------
#pragma mark - Initilisers
//--------------------------------------------------------
+(instancetype)optionsReader{
    KFXOptionsReader *reader = [[[self class]alloc]init];
    return reader;
}

//--------------------------------------------------------
#pragma mark - Build Configurations
//--------------------------------------------------------
-(KFXBuildConfiguration)actualbuildConfiguration{
    KFXBuildConfiguration buildConfig;

#if ADHOC
        buildConfig = KFXBuildConfigurationAdHoc;
#elif DEBUG
        buildConfig = KFXBuildConfigurationDebug;
#else
        buildConfig = KFXBuildConfigurationRelease;
#endif    
    return buildConfig;
}

-(KFXLogMediums)logMediumsForBuildConfiguration:(KFXBuildConfiguration)buildConfig{
    
    KFXLogConfigurator *configurator = [KFXLogConfigurator sharedConfigurator];
    
    // ## Determine KFXLogMediums for current build configuration
    KFXLogMediums logMediums;
    switch (buildConfig) {
        case KFXBuildConfigurationDebug:
            logMediums = configurator.debugLogMediums;
            break;
        case KFXBuildConfigurationAdHoc:
            logMediums = configurator.adHocLogMediums;
            break;
        case KFXBuildConfigurationRelease:
            logMediums = configurator.releaseLogMediums;
            break;
        default:
            logMediums = 0;
            break;
    }
    
    return logMediums;

}

//--------------------------------------------------------
#pragma mark - Create Strings
//--------------------------------------------------------
-(NSString *)buildConfigurationName{

    KFXLogConfigurator *configurator = [KFXLogConfigurator sharedConfigurator];
    
    NSString *buildConfig;
    switch (configurator.buildConfiguration) {
        case KFXBuildConfigurationNone: {
            buildConfig = @"Not Specified";
            break;
        }
        case KFXBuildConfigurationDebug: {
            buildConfig = @"Debug";
            break;
        }
        case KFXBuildConfigurationAdHoc: {
            buildConfig = @"AdHoc";
            break;
        }
        case KFXBuildConfigurationRelease: {
            buildConfig = @"Release";
            break;
        }
    }
    return buildConfig;
}

-(NSString*)actualBuildConfigurationName{
    
    // ## Determine current build configuration, work it out using preprocessor macro
    NSString *buildConfig;
#if ADHOC
    buildConfig = @"AdHoc";
#elif DEBUG
    buildConfig = @"Debug";
#else
    buildConfig = @"Release";
#endif
    return buildConfig;
}

-(NSString*)logOptionSummaryForBuildConfiguration:(KFXBuildConfiguration)buildConfig{
    
    // ## Determine logOptions for current build configuration
    KFXLogMediums logMediums = [self logMediumsForBuildConfiguration:buildConfig];
    
    // ## Collect strings for all options that have been set
    NSMutableArray *options = [NSMutableArray arrayWithCapacity:4];
    if (logMediums == 0) {
        [options addObject:@"Off"];
    }
    if (logMediums & KFXLogMediumConsole) {
        [options addObject:@"ToConsole"];
    }
    if (logMediums & KFXLogMediumAlert) {
        [options addObject:@"ToAlert"];
    }
    if (logMediums & KFXLogMediumFile) {
        [options addObject:@"ToFile"];
    }
    if (logMediums & KFXLogMediumService) {
        [options addObject:@"ToService"];
    }
    
    // ## Combine strings with pipe in between each
    NSMutableString *optionsMutString = [[NSMutableString alloc]init];
    for (NSUInteger idx = 0; idx < options.count; idx++) {
        if (idx == 0) {
            [optionsMutString appendString:options.firstObject];
        }else if (idx+1 == options.count){
            if (options.count == 2) {
                [optionsMutString appendFormat:@" | %@",options.lastObject];
            }else{
                [optionsMutString appendString:options.lastObject];
            }
        }else{
            [optionsMutString appendFormat:@" | %@ |",options[idx]];
        }
    }
    
    
    return [optionsMutString copy];
}

-(NSString *)consoleLogType{
    
    KFXLogConfigurator *configurator = [KFXLogConfigurator sharedConfigurator];

    switch (configurator.consoleLogType) {
        case KFXConsoleLogTypeBasic: {
            return @"Basic";
            break;
        }
        case KFXConsoleLogTypeClean: {
            return @"Clean";
            break;
        }
    }
}

-(NSString *)consoleLogOptions{
    
    KFXLogConfigurator *configurator = [KFXLogConfigurator sharedConfigurator];
    
    NSString *descriptorSummary;
    
    switch (configurator.consoleLogType) {
        case KFXConsoleLogTypeBasic: {
            
            KFXBasicLogDescriptor *descriptor = configurator.basicLogDescriptor;
            NSString *showSender = [self showSenderForDescriptor:descriptor];
            NSString *senderPlacement = [self senderPlacementForDescriptor:descriptor];
            
            descriptorSummary = [NSString stringWithFormat:@"\n\t## Standard Log Summary ## \n\t\tShow Sender: %@;\n\t\tSender Placement: %@",showSender,senderPlacement];
            
            break;
        }
        case KFXConsoleLogTypeClean: {

            KFXCleanLogDescriptor *descriptor = configurator.cleanLogDescriptor;
            NSString *showSender = [self showSenderForDescriptor:descriptor];
            NSString *senderPlacement = [self senderPlacementForDescriptor:descriptor];
            NSString *order = [self orderForDescriptor:descriptor];
            NSString *showDate = descriptor.showDate ? @"YES" : @"NO";
            NSString *logFormat = [self logFormatStyle:descriptor.logFormat];
            
            descriptorSummary = [NSString stringWithFormat:@"\n\t## Clean Log Summary ## \n\t\tLog Format Style: %@;\n\t\tShow Sender: %@;\n\t\tSender Placement: %@;\n\t\tOrder: %@;\n\t\tShow Date: %@;\n\t\tBullet Point: \"%@\";\n\t\tMax Indent: %lu;\n\t\tIndent Char: '%c';\n\t\tLeading New Lines: %lu",logFormat,showSender,senderPlacement,order,showDate,descriptor.bulletPoint,(unsigned long)descriptor.maxIndent,descriptor.indentChar,(unsigned long)descriptor.leadingNewLines];

            break;
        }
    }

    return descriptorSummary;
}

-(NSString *)fileLogOptions{
    
    KFXLogConfigurator *configurator = [KFXLogConfigurator sharedConfigurator];

    KFXFileLogDescriptor *descriptor = configurator.fileLogDescriptor;
    NSString *showSender = [self showSenderForDescriptor:descriptor];
    NSString *senderPlacement = [self senderPlacementForDescriptor:descriptor];
    NSString *order = [self orderForDescriptor:descriptor];
    NSString *showDate = descriptor.showDate ? @"YES" : @"NO";
    NSString *logFormat = [self logFormatStyle:descriptor.logFormat];

    NSString *descriptorSummary = [NSString stringWithFormat:@"\n\t## File Log Summary ## \n\t\tLog Format Style: %@;\n\t\tShow Sender: %@;\n\t\tSender Placement: %@;\n\t\tOrder: %@;\n\t\tShow Date: %@;\n\t\tBullet Point: \"%@\";\n\t\tMax Indent: %lu;\n\t\tIndent Char: '%c';\n\t\tLeading New Lines: %lu",logFormat,showSender,senderPlacement,order,showDate,descriptor.bulletPoint,(unsigned long)descriptor.maxIndent,descriptor.indentChar,(unsigned long)descriptor.leadingNewLines];

    return descriptorSummary;
}

-(NSString *)alertLogOptions{
    
    KFXLogConfigurator *configurator = [KFXLogConfigurator sharedConfigurator];
    
    KFXAlertLogDescriptor *descriptor = configurator.alertLogDescriptor;
    NSString *showSender = [self showSenderForDescriptor:descriptor];
    NSString *senderPlacement = [self senderPlacementForDescriptor:descriptor];
    NSString *order = [self orderForDescriptor:descriptor];
    NSString *showDate = descriptor.showDate ? @"YES" : @"NO";
    NSString *shouldFormat = descriptor.shouldFormatMessage ? @"YES" : @"NO";
    NSString *logFormat = [self logFormatStyle:descriptor.logFormat];

    NSString *descriptorSummary = [NSString stringWithFormat:@"\n\t## Alert Log Summary ## \n\t\tLog Format Style: %@;\n\t\tShould Format: %@;\n\t\tShow Sender: %@;\n\t\tSender Placement: %@;\n\t\tOrder: %@;\n\t\tShow Date: %@;\n\t\tBullet Point: \"%@\";\n\t\tMax Indent: %lu;\n\t\tIndent Char: '%c';\n\t\tLeading New Lines: %lu",logFormat,shouldFormat,showSender,senderPlacement,order,showDate,descriptor.bulletPoint,(unsigned long)descriptor.maxIndent,descriptor.indentChar,(unsigned long)descriptor.leadingNewLines];
    
    return descriptorSummary;
}

-(NSString *)serviceLogOptions{
    KFXLogConfigurator *configurator = [KFXLogConfigurator sharedConfigurator];
    
    NSString *descriptorSummary;
    
    KFXServiceLogDescriptor *descriptor = configurator.serviceLogDescriptor;
    NSString *showSender = [self showSenderForDescriptor:descriptor];
    NSString *senderPlacement = [self senderPlacementForDescriptor:descriptor];
    NSString *order = [self orderForDescriptor:descriptor];
    NSString *showDate = descriptor.showDate ? @"YES" : @"NO";
    NSString *shouldFormat = descriptor.shouldFormatMessage ? @"YES" : @"NO";
    NSString *logFormat = [self logFormatStyle:descriptor.logFormat];

    descriptorSummary = [NSString stringWithFormat:@"\n\t## Service Log Summary ## \n\t\tLog Format Style: %@;\n\t\tShould Format: %@;\n\t\tShow Sender: %@;\n\t\tSender Placement: %@;\n\t\tOrder: %@;\n\t\tShow Date: %@;\n\t\tBullet Point: \"%@\";\n\t\tMax Indent: %lu;\n\t\tIndent Char: '%c';\n\t\tLeading New Lines: %lu",logFormat,shouldFormat,showSender,senderPlacement,order,showDate,descriptor.bulletPoint,(unsigned long)descriptor.maxIndent,descriptor.indentChar,(unsigned long)descriptor.leadingNewLines];
    
    return descriptorSummary;
}


-(NSString*)showSenderForDescriptor:(KFXLogDescriptor*)descriptor{
    
    NSString *showSender;
    
    switch (descriptor.showSender) {
        case KFXShowSenderNever: {
            showSender = @"Never";
            break;
        }
        case KFXShowSenderDescription: {
            showSender = @"Description";
            break;
        }
        case KFXShowSenderDebugDescription: {
            showSender = @"Debug Description";
            break;
        }
        case KFXShowSenderClassOnly: {
            showSender = @"Class Only";
            break;
        }
        case KFXShowSenderDescriptionAndClass: {
            showSender = @"Description & Class";
            break;
        }
        case KFXShowSenderDebugDescriptionAndClass: {
            showSender = @"Debug Description & Class";
            break;
        }
    }
    return showSender;
}

-(NSString*)senderPlacementForDescriptor:(KFXLogDescriptor*)descriptor{
    
    NSString *placement;
    switch (descriptor.senderPlacement) {
        case KFXSenderPlacementEnd: {
            placement = @"End";
            break;
        }
        case KFXSenderPlacementBeginning: {
            placement = @"Beginning";
            break;
        }
    }
    return placement;
}

-(NSString*)orderForDescriptor:(KFXFormattedLogDescriptor*)descriptor{
    
    NSString *order;
    
    switch (descriptor.order) {
        case KFXLogOrderDatePrefixIndent: {
            order = @"Date - Prefix - Indent";
            break;
        }
        case KFXLogOrderDateIndentPrefix: {
            order = @"Date - Indent - Prefix";
            break;
        }
        case KFXLogOrderPrefixDateIndent: {
            order = @"Prefix - Date - Indent";
            break;
        }
        case KFXLogOrderPrefixIndentDate: {
            order = @"Prefix - Indent - Date";
            break;
        }
        case KFXLogOrderIndentPrefixDate: {
            order = @"Indent - Prefix - Date";
            break;
        }
        case KFXLogOrderIndentDatePrefix: {
            order = @"Indent - Date - Prefix";
            break;
        }
    }
    
    return order;
}


-(NSString*)logFormatStyle:(KFXLogFormat)logFormat{
    
    NSString *string;
    switch (logFormat) {
        case KFXLogFormatFir: {
            string = @"Fir";
            break;
        }
        case KFXLogFormatAsh: {
            string = @"Ash";
            break;
        }
        case KFXLogFormatWalnut: {
            string = @"Walnut";
            break;
        }
        case KFXLogFormatTeak: {
            string = @"Teak";
            break;
        }
        case KFXLogFormatBalsa: {
            string = @"Balsa";
            break;
        }
        case KFXLogFormatMahogany: {
            string = @"Mahogany";
            break;
        }
        case KFXLogFormatBirch: {
            string = @"Birch";
            break;
        }
        case KFXLogFormatOak: {
            string = @"Oak";
            break;
        }
        case KFXLogFormatPine: {
            string = @"Pine";
            break;
        }
        case KFXLogFormatMaple: {
            string = @"Maple";
            break;
        }
        case KFXLogFormatCherry: {
            string = @"Cherry";
            break;
        }
        case KFXLogFormatRedwood: {
            string = @"Redwood";
            break;
        }
        case KFXLogFormatHolly: {
            string = @"Holly";
            break;
        }
    }
    return string;
    
}
                               
                                 
//======================================================
#pragma mark - ** Private Methods **
//======================================================
//--------------------------------------------------------
#pragma mark - Lazy Load
//--------------------------------------------------------




@end
