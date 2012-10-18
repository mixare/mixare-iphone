//
//  WikipediaProcessorTest.m
//  Mixare
//
//  Created by Aswin Ly on 18-10-12.
//  Copyright (c) 2012 Peer GmbH. All rights reserved.
//

#import "WikipediaProcessorTest.h"

@implementation WikipediaProcessorTest

- (void)setUp {
    [super setUp];
    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCreateWikipediaProcessor {
    id<DataProcessor> processor = [[WikipediaProcessor alloc] init];
    STAssertNotNil(processor, @"Not created");
}

- (void)testConvertWikipediaData {
    id<DataProcessor> processor = [[WikipediaProcessor alloc] init];
    NSMutableArray* converted = [processor convert:@"{\"geonames\":[{\"summary\":\"De Woensdrechtse Heide is een natuurgebied van 69 ha, dat eigendom is van Defensie. Het betreft een militair oefenterrein dat ingeklemd ligt tussen Vliegbasis Woensdrecht, landgoed Mattemburgh, en Zurenhoek. Het gebied bestaat uit heide, stuifzand en naaldbos. De heide werd geregenereerd (...)\",\"distance\":\"0\",\"rank\":7,\"title\":\"Woensdrechtse Heide\",\"wikipediaUrl\":\"nl.wikipedia.org/wiki/Woensdrechtse_Heide\",\"lng\":0,\"lang\":\"nl\",\"lat\":0},{\"summary\":\"De evenaar, evennachtslijn of equator is een denkbeeldige lijn op het aardoppervlak in de vorm van een grootcirkel midden tussen de polen. De evenaar verdeelt de aarde in een noordelijk halfrond en een zuidelijk halfrond (...)\",\"distance\":\"0\",\"rank\":98,\"title\":\"Evenaar\",\"wikipediaUrl\":\"nl.wikipedia.org/wiki/Evenaar\",\"lng\":0,\"thumbnailImg\":\"http://www.geonames.org/img/wikipedia/141000/thumb-140512-100.jpg\",\"lang\":\"nl\",\"lat\":0}]}"];
    NSString *title = [[NSString alloc] initWithString:[[converted objectAtIndex:0] valueForKey:@"title"]];
    NSLog(@"CONVERTED TITLE: %@", title);
    STAssertEqualObjects(title, @"Woensdrechtse Heide", @"Convert failed");
}

@end
