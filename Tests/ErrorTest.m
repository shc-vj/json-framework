/*
 Copyright (C) 2007-2011 Stig Brautaset. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:

 * Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

 * Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

 * Neither the name of the author nor the names of its contributors
   may be used to endorse or promote products derived from this
   software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */

#import "SBJson5.h"
#import <XCTest/XCTest.h>


#define SBAssertStringContains(e, s) \
XCTAssertTrue([e rangeOfString:s].location != NSNotFound, @"%@ vs %@", e, s)

@interface ErrorTest : XCTestCase
@end

@implementation ErrorTest {
    SBJson5Writer * writer;
}

- (void)setUp {
    writer = [SBJson5Writer new];
}

- (void)testNonStringDictionaryKey {
    NSArray *keys = [NSArray arrayWithObjects:[NSNull null],
                     [NSNumber numberWithInt:1],
                     [NSArray array],
                     [NSDictionary dictionary],
                     nil];

    for (id key in keys) {
        NSDictionary *object = [NSDictionary dictionaryWithObject:@"1" forKey:key];
        XCTAssertEqualObjects([writer stringWithObject:object], nil);
        XCTAssertNotNil(writer.error);
    }
}

- (void)testParseNil {
    id parser = [SBJson5Parser parserWithBlock:^(id o, BOOL *string) {
        XCTFail(@"");
    }
                                  errorHandler:^(NSError *error) {
                                      XCTAssertEqualObjects(error, @"Input was 'nil'");
                                  }];
    [parser parse:nil];
}

- (void)testWriteNil {
    XCTAssertNil([writer stringWithObject:nil]);
    SBAssertStringContains(writer.error, @"JSON serialisation not supported for (null)");

}

@end
