/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2014, OpenRemote Inc.
 *
 * See the contributors.txt file in the distribution for a
 * full listing of individual contributors.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
#import "ORSwitchParserTest.h"
#import "DefinitionElementParserRegister.h"
#import "XMLEntity.h"
#import "ORSwitchParser.h"
#import "ORSensorLinkParser.h"
#import "ORSensorStateParser.h"
#import "DefinitionParserMock.h"
#import "ORSwitch.h"
#import "ORImage.h"
#import "ORObjectIdentifier.h"

@implementation ORSwitchParserTest

- (DefinitionElementParser *)parseXMLSnippet:(NSString *)snippet
{
    DefinitionElementParserRegister *depRegistry = [[DefinitionElementParserRegister alloc] init];
    [depRegistry registerParserClass:[ORSwitchParser class] endSelector:@selector(setTopLevelParser:) forTag:SWITCH];
    [depRegistry registerParserClass:[ORSensorLinkParser class] endSelector:@selector(endSensorLinkElement:) forTag:LINK];
    [depRegistry registerParserClass:[ORSensorStateParser class] endSelector:@selector(endSensorStateElement:) forTag:STATE];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[snippet dataUsingEncoding:NSUTF8StringEncoding]];
    DefinitionParserMock *parser = [[DefinitionParserMock alloc] initWithRegister:depRegistry attributes:nil];
    [parser addKnownTag:SWITCH];
    [xmlParser setDelegate:parser];
    [xmlParser parse];
    
    return parser.topLevelParser;
}

- (ORSwitch *)parseValidXMLSnippet:(NSString *)snippet
{
    DefinitionElementParser *topLevelParser = [self parseXMLSnippet:snippet];
    XCTAssertNotNil(topLevelParser, @"Valid XML snippet should be parsed correctly");
    XCTAssertTrue([topLevelParser isMemberOfClass:[ORSwitchParser class]], @"Parser used should be an ORSwitchParser");
    ORSwitch *sswitch = ((ORSwitchParser *)topLevelParser).sswitch;
    XCTAssertNotNil(sswitch, @"A switch should be parsed for given XML snippet");
    
    return sswitch;
}

- (void)testParseSwitchNoSensor
{
    ORSwitch *sswitch = [self parseValidXMLSnippet:@"<switch id=\"10\"/>"];

    XCTAssertNotNil(sswitch.identifier, @"Parsed switch should have an identifier");
    XCTAssertEqualObjects(sswitch.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed switch should have 10 as identifer");

    XCTAssertNil(sswitch.onImage, @"Parsed switch should not have any on image defined");
    XCTAssertNil(sswitch.offImage, @"Parsed switch should not have any on image defined");
}

- (void)testParseSwitchSensorWithImages
{
    ORSwitch *sswitch = [self parseValidXMLSnippet:@"<switch id=\"10\"><link type=\"sensor\" ref=\"20\"><state name=\"on\" value=\"OnImage.png\"/><state name=\"off\" value=\"OffImage.png\"/></link></switch>"];

    XCTAssertNotNil(sswitch.identifier, @"Parsed switch should have an identifier");
    XCTAssertEqualObjects(sswitch.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed switch should have 10 as identifer");

    XCTAssertNotNil(sswitch.onImage, @"Parsed switch should have an on image defined");
    XCTAssertEqualObjects(sswitch.onImage.src, @"OnImage.png", @"Parsed switch on image src should be 'OnImage.png'");

    XCTAssertNotNil(sswitch.offImage, @"Parsed switch should have an off image defined");
    XCTAssertEqualObjects(sswitch.offImage.src, @"OffImage.png", @"Parsed switch off image src should be 'OffImage.png'");
}

@end