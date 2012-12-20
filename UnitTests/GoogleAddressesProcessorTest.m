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
//  GoogleAddressesProcessorTest.m
//  Mixare
//
//  Created by Aswin Ly on 18-12-12.
//

#import "GoogleAddressesProcessorTest.h"

@implementation GoogleAddressesProcessorTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCreateGoogleAddressesProcessor {
    id<DataProcessor> processor = [[GoogleAddressesProcessor alloc] init];
    STAssertNotNil(processor, @"Not created");
}

- (void)testConvertGoogleAddressesData {
    id<DataProcessor> processor = [[GoogleAddressesProcessor alloc] init];
    NSMutableArray* converted = [processor convert:@"{\"results\":[{\"address_components\":[{\"long_name\":\"46\",\"short_name\":\"46\",\"types\":[\"street_number\"]},{\"long_name\":\"Stationsplein\",\"short_name\":\"Stationsplein\",\"types\":[\"route\"]},{\"long_name\":\"C.S. Kwartier\",\"short_name\":\"C.S. Kwartier\",\"types\":[\"sublocality\",\"political\"]},{\"long_name\":\"Centrum\",\"short_name\":\"Centrum\",\"types\":[\"sublocality\",\"political\"]},{\"long_name\":\"Rotterdam\",\"short_name\":\"Rotterdam\",\"types\":[\"locality\",\"political\"]},{\"long_name\":\"Rotterdam\",\"short_name\":\"Rotterdam\",\"types\":[\"administrative_area_level_2\",\"political\"]},{\"long_name\":\"Zuid-Holland\",\"short_name\":\"ZH\",\"types\":[\"administrative_area_level_1\",\"political\"]},{\"long_name\":\"Nederland\",\"short_name\":\"NL\",\"types\":[\"country\",\"political\"]},{\"long_name\":\"3013 AK\",\"short_name\":\"3013 AK\",\"types\":[\"postal_code\"]}],\"formatted_address\":\"Stationsplein 46, 3013 AK Rotterdam, Nederland\",\"geometry\":{\"location\":{\"lat\":51.92339830,\"lng\":4.46913610},\"location_type\":\"ROOFTOP\",\"viewport\":{\"northeast\":{\"lat\":51.92474728029150,\"lng\":4.470485080291502},\"southwest\":{\"lat\":51.92204931970850,\"lng\":4.467787119708498}}},\"types\":[\"street_address\"]}],\"status\":\"OK\"}"];
    NSString *title = [[NSString alloc] initWithString:[converted[0] valueForKey:@"title"]];
    NSLog(@"CONVERTED TITLE: %@", title);
    STAssertEqualObjects(title, @"Stationsplein 46, 3013 AK Rotterdam, Nederland", @"Convert failed");
}

@end
