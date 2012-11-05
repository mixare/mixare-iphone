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
//  TwitterProcessorTest.m
//  Mixare
//
//  Created by Aswin Ly on 18-10-12.
//

#import "TwitterProcessorTest.h"

@implementation TwitterProcessorTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCreateTwitterProcessor {
    id<DataProcessor> processor = [[TwitterProcessor alloc] init];
    STAssertNotNil(processor, @"Not created");
}

- (void)testConvertTwitterData {
    id<DataProcessor> processor = [[TwitterProcessor alloc] init];
    NSMutableArray* converted = [processor convert:@"{\"completed_in\":0.06,\"max_id\":258807792629080064,\"max_id_str\":\"258807792629080064\",\"page\":1,\"query\":\"\",\"refresh_url\":\"?since_id=258807792629080064&q=&geocode=0%2C0%2C0km\",\"results\":[{\"created_at\":\"Thu, 18 Oct 2012 05:52:40 +0000\",\"from_user\":\"georgeong\",\"from_user_id\":45152327,\"from_user_id_str\":\"45152327\",\"from_user_name\":\"George\",\"geo\":null,\"location\":\"0.000000,000.000000\",\"id\":258807792629080064,\"id_str\":\"258807792629080064\",\"iso_language_code\":\"en\",\"metadata\":{\"result_type\":\"recent\"},\"profile_image_url\":\"http:\/\/a0.twimg.com\/profile_images\/2729311390\/1e611d7f66d87287bf5ffaef0328a9d1_normal.jpeg\",\"profile_image_url_https\":\"https:\/\/si0.twimg.com\/profile_images\/2729311390\/1e611d7f66d87287bf5ffaef0328a9d1_normal.jpeg\",\"source\":\"&lt;a href=&quot;http:\/\/twitter.com\/tweetbutton&quot;&gt;Tweet Button&lt;\/a&gt;\",\"text\":\"SingTel subscriber's Facebook post goes viral - http:\/\/t.co\/mAG7HWTX\",\"to_user\":null,\"to_user_id\":0,\"to_user_id_str\":\"0\",\"to_user_name\":null},{\"created_at\":\"Thu, 18 Oct 2012 04:36:25 +0000\",\"from_user\":\"georgeong\",\"from_user_id\":45152327,\"from_user_id_str\":\"45152327\",\"from_user_name\":\"George\",\"geo\":{ \"coordinates\" : [ 50.344538999999997, 5.4248859999999999 ], \"type\" : \"Point\"},\"location\":\"0.000000,000.000000\",\"id\":258788603528884224,\"id_str\":\"258788603528884224\",\"iso_language_code\":\"en\",\"metadata\":{\"result_type\":\"recent\"},\"profile_image_url\":\"http:\/\/a0.twimg.com\/profile_images\/2729311390\/1e611d7f66d87287bf5ffaef0328a9d1_normal.jpeg\",\"profile_image_url_https\":\"https:\/\/si0.twimg.com\/profile_images\/2729311390\/1e611d7f66d87287bf5ffaef0328a9d1_normal.jpeg\",\"source\":\"&lt;a href=&quot;http:\/\/twitter.com\/tweetbutton&quot;&gt;Tweet Button&lt;\/a&gt;\",\"text\":\"RT @PCMag The Pirate Bay Ditches Servers, Embraces the Cloud http:\/\/t.co\/Zy2Fwsr3\",\"to_user\":null,\"to_user_id\":0,\"to_user_id_str\":\"0\",\"to_user_name\":null}],\"results_per_page\":15,\"since_id\":0,\"since_id_str\":\"0\"}"];
    NSString *title = [[NSString alloc] initWithString:[converted[0] valueForKey:@"title"]];
    NSLog(@"CONVERTED TITLE: %@", title);
    STAssertEqualObjects(title, @"RT @PCMag The Pirate Bay Ditches Servers, Embraces the Cloud http:\/\/t.co\/Zy2Fwsr3", @"Convert failed");
}


@end
