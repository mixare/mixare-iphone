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
//  WikipediaProcessorTest.m
//  Mixare
//
//  Created by Aswin Ly on 18-10-12.
//

#import "WikipediaProcessorTest.h"

@implementation WikipediaProcessorTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCreateWikipediaProcessor {
    id<DataProcessor> processor = [[WikipediaProcessor alloc] init];
    STAssertNotNil(processor, @"Not created");
}

- (void)testConvertWikipediaData {
    id<DataProcessor> processor = [[WikipediaProcessor alloc] init];
    NSMutableArray* converted = [processor convert:@"{\"geonames\":[{\"summary\":\"De Woensdrechtse Heide is een natuurgebied van 69 ha, dat eigendom is van Defensie. Het betreft een militair oefenterrein dat ingeklemd ligt tussen Vliegbasis Woensdrecht, landgoed Mattemburgh, en Zurenhoek. Het gebied bestaat uit heide, stuifzand en naaldbos. De heide werd geregenereerd (...)\",\"distance\":\"0\",\"rank\":7,\"title\":\"Woensdrechtse Heide\",\"wikipediaUrl\":\"nl.wikipedia.org/wiki/Woensdrechtse_Heide\",\"lng\":0,\"lang\":\"nl\",\"lat\":0},{\"summary\":\"De evenaar, evennachtslijn of equator is een denkbeeldige lijn op het aardoppervlak in de vorm van een grootcirkel midden tussen de polen. De evenaar verdeelt de aarde in een noordelijk halfrond en een zuidelijk halfrond (...)\",\"distance\":\"0\",\"rank\":98,\"title\":\"Evenaar\",\"wikipediaUrl\":\"nl.wikipedia.org/wiki/Evenaar\",\"lng\":0,\"thumbnailImg\":\"http://www.geonames.org/img/wikipedia/141000/thumb-140512-100.jpg\",\"lang\":\"nl\",\"lat\":0}]}"];
    NSString *title = [[NSString alloc] initWithString:[converted[0] valueForKey:@"title"]];
    NSLog(@"CONVERTED TITLE: %@", title);
    STAssertEqualObjects(title, @"Woensdrechtse Heide", @"Convert failed");
}

@end
