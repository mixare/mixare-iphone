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
//  DataConvertor.m
//  Mixare
//
//  Created by Aswin Ly on 15-10-12.
//  Copyright (c) 2012 Peer GmbH. All rights reserved.
//

#import "DataConvertor.h"
#import "TwitterProcessor.h"
#import "WikipediaProcessor.h"
#import "MixareProcessor.h"

static NSMutableArray* dataProcessors;
static DataConvertor* instance;

@implementation DataConvertor

+(DataConvertor*) init {
    if (dataProcessors == nil) {
        dataProcessors = [NSMutableArray alloc];
        [self initDataProcessors];
    }
    if (instance == nil) {
        instance = [DataConvertor alloc];
    }
    return instance;
}

+(void) initDataProcessors {
    [dataProcessors addObject:[TwitterProcessor alloc]];
    [dataProcessors addObject:[WikipediaProcessor alloc]];
    [dataProcessors addObject:[MixareProcessor alloc]];
}

+(NSArray*) dataProcessors {
    return dataProcessors;
}

@end
