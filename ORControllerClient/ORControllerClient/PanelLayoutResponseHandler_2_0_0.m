/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2013, OpenRemote Inc.
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

#import "PanelLayoutResponseHandler_2_0_0.h"
#import "PanelDefinitionParser.h"
#import "ORResponseHandler_Private.h"

@interface PanelLayoutResponseHandler_2_0_0 ()

@property (strong, nonatomic) void (^_successHandler)(Definition *);

@end

@implementation PanelLayoutResponseHandler_2_0_0

- (instancetype)initWithSuccessHandler:(void (^)(Definition *))successHandler errorHandler:(void (^)(NSError *))errorHandler
{
    self = [super init];
    if (self) {
        self._successHandler = successHandler;
        self._errorHandler = errorHandler;
    }
    return self;
}

- (void)processValidResponseData:(NSData *)receivedData
{
    PanelDefinitionParser *parser = [[PanelDefinitionParser alloc] init];
    Definition *definition = [parser parseDefinitionFromXML:receivedData];
//    if (definition) {
        self._successHandler(definition);
// TODO: handle parsing errors -> error handler

//    } else {
//        self._errorHandler(parser.parseError);
//    }
}

@end
