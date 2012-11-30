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
//  StartWithMeDemo.m
//  Mixare
//
//  Created by Aswin Ly on 19-11-12.
//

#import "StartWithMeDemo.h"

@implementation StartWithMeDemo

- (void)run:(id<StartMain>)delegate {
    mainClass = delegate;
    //  ADD HERE YOUR PRE-STUFF
    //  RUN ME BEFORE APPLICATION STARTS (Like an extra view)
    //  YOU CAN ALSO GET THE MANAGERS: DataSourceManager and LocationManager
    //  TO MANAGE THE DATA BY YOUR OWN
    NSLog(@"Plugin loaded");
    [mainClass showHud];                    //  Show indicator
	[self performSelectorInBackground:@selector(threadLoad) withObject:nil];
}

- (void)threadLoad {
    //[mainClass setPluginDelegate:self];   //  Add this if you want the possibility to go back to this plugin from AR-View
    [mainClass setToggleMenu:YES];          //  Make the menu-button available on AR-View
    [mainClass refresh];                    //  Download Data
    [mainClass openARView];                 //  Open AR-View
    [mainClass closeHud];                   //  Close indicator
}

@end
