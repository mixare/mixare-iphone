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
//  BootView.m
//  Mixare
//
//  Created by Aswin Ly on 19-11-12.
//

#import "BootView.h"

@implementation BootView

- (void)run:(id<StartMainDelegate>)delegate {
    mainClass = delegate;
    [mainClass setToggleMenuButton:YES];
    [mainClass setToggleReturnButton:NO];
    [mainClass setPluginDelegate:self];
	[mainClass window].rootViewController = nil;
    [self reuse];
}

- (void)reuse {
    [mainClass showHud];
    [self performSelectorInBackground:@selector(threadLoad) withObject:nil];
}

- (void)threadLoad {
    [mainClass refresh];                    //  Download Data
    [mainClass openARView];                 //  Open AR-View
    [mainClass closeHud];                   //  Close indicator
}

@end
