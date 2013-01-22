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
//  Resources.m
//  Mixare
//
//  Created by Aswin Ly on 22-01-13.
//

#import "Resources.h"

@implementation Resources

static Resources *resources;

+ (void)initialize {
    if (self == [Resources class]){
        resources = [[Resources alloc] init];
    }
}

+ (id)getInstance {
    return resources;
}

- (NSBundle*)bundle {
    return [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"Resources" withExtension:@"bundle"]];
}

@end
