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
//  DataSourceManager.h
//  Mixare
//
//  Created by Aswin Ly on 05-10-12.
//

#import <Foundation/Foundation.h>
#import "DataSource.h"

@interface DataSourceManager : NSObject{
    NSMutableArray *dataSources;
}

@property (nonatomic, strong) NSMutableArray *dataSources;

- (id)init;
- (DataSource*)getDataSourceByTitle:(NSString*)title;
- (NSMutableArray*)getActivatedSources;
- (DataSource*)createDataSource:(NSString*)title dataUrl:(NSString*)url;
- (void)deleteDataSource:(DataSource*)source;
- (void)deactivateAllSources;

@end
