/*
 * Copyright (C) 2010- Peer internet solutions
 *
 * This file is part of mixare.
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License
 * for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program. If not, see <http://www.gnu.org/licenses/>
 */
//
//  StandardInput.m
//  Mixare
//
//  Created by Aswin Ly on 13-11-12.
//

#import "StandardInput.h"

@implementation StandardInput

- (id)init {
    self = [super init];
    return self;
}

- (NSString*)getTitle {
    return @"Standard Text Input";
}

- (void)runInput:(id<SetDataSourceDelegate>)classToSetYourData {
    aClass = classToSetYourData;
    [self initInputView];
}

- (void)initInputView {
    UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Add Source",nil)
                                                       message:NSLocalizedString(@"Insert your Source address \n\n\n\n\n",nil)
                                                      delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                                             otherButtonTitles:NSLocalizedString(@"OK",nil), nil];
    
    textField = [[UITextField alloc] init];
    [textField setBackgroundColor:[UIColor whiteColor]];
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleLine;
    textField.frame = CGRectMake(15, 75, 255, 30);
    textField.font = [UIFont fontWithName:@"ArialMT" size:20];
    textField.placeholder = NSLocalizedString(@"Title",nil);
    textField.textAlignment = NSTextAlignmentCenter;
    textField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [textField becomeFirstResponder];
    [addAlert addSubview:textField];
    
    urlField = [[UITextField alloc] init];
    [urlField setBackgroundColor:[UIColor whiteColor]];
    urlField.delegate = self;
    urlField.borderStyle = UITextBorderStyleLine;
    urlField.frame = CGRectMake(15, 120, 255, 30);
    urlField.font = [UIFont fontWithName:@"ArialMT" size:20];
    urlField.placeholder = NSLocalizedString(@"Format:www.example.com",nil);
    urlField.textAlignment = NSTextAlignmentCenter;
    urlField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [addAlert addSubview:urlField];
    [addAlert show];
}

- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        if (textField.text == nil || urlField.text == nil) {
            [aClass setNewData:@{@"title":@"", @"url":@""}];
        } else {
            [aClass setNewData:@{@"title":textField.text, @"url":urlField.text}];
        }
    }
}

@end
