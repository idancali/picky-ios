//
// PickySpec.m
//
// Copyright (c) 2014 Dan Calinescu (http://dancali.io)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#define EXP_SHORTHAND YES

#import "Specta.h"
#import "Expecta.h"
#import "OCMock.h"
#import "Nocilla.h"
#import "PickySharedSpec.m"

#import "Picky.h"
#import "PickySearchOperation.h"

SpecBegin(Picky)

// We want to handle Picky search results, so let's check for search result scenarios
describe(@"Search", ^{
   
    // We're going to use this queue to test our scenario async operations
    __block NSOperationQueue* _queue    =   nil;

    // This is our test bundle that's we're going to use to store test resources for all of our scenarios
    __block NSBundle* _bundle           =   nil;

    // This is just a simple helper block that allows us to neatly store expected JSON results in test files in our test bundle
    __block NSString* (^loadExpectedJsonResultFromFile)(NSString* filename) = ^(NSString* filename){return [NSJSONSerialization JSONObjectWithData:[[NSString stringWithContentsOfFile:[_bundle pathForResource:filename ofType:@"json"] encoding:NSUTF8StringEncoding error:NULL] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];};
    
    beforeAll(^{
        // We're only going to do this once, and we're going to re-use the bundle for all scenarios
        _bundle          = [NSBundle bundleForClass:[self class]];
        
        // We're only going to setup a queue once
        _queue           = [[NSOperationQueue alloc] init];
        
        // Let's start stubbing calls; we're not interested in testing networking
        [[LSNocilla sharedInstance] start];
        [Expecta setAsynchronousTestTimeout:5.0];
    });
    
    // This is our first scenario we want to validate; can we parse a single allocation?
    it (@"Can parse a single allocation", ^{
        itShouldBehaveLike(SHARED_PARSE_SINGLE_ALLOCATION, @{@"json" : loadExpectedJsonResultFromFile(@"single-allocation-search")});
    });
    
    // Let's get crazy now - can we parse multiple allocations?
    it (@"Can parse multiple allocations", ^{
        itShouldBehaveLike(SHARED_PARSE_MULTIPLE_ALLOCATIONS, @{@"json" : loadExpectedJsonResultFromFile(@"multiple-allocations-search")});
    });

    // Alright, now that we've settled the parsing scenarions, let's see if we can handle a basic operation flow
    // We're going to use the basic Picky server response as our reference point: http://picky-simple-example.heroku.com
    it (@"Can perform search operations", ^AsyncBlock {
       
        // Here's the request we're checking: http://picky-simple-example.heroku.com/search/full?query=alan&offset=0
        NSString* url = @"http://picky-simple-example.heroku.com/search/full";
        NSDictionary* params = @{@"query" : @"alan", @"offset" : @"0"};
        NSString* expectedJsonResponse = loadExpectedJsonResultFromFile(@"multiple-allocations-search");

        // Our purpose is to verify our flow, not to test networking so let's stub out the call for now
        stubRequest(@"GET", [NSString stringWithFormat:@"%@?%@", url, params]).andReturn(200).
        withHeaders(@{@"Content-Type": @"application/json"}).
        withBody (expectedJsonResponse);
        
        // This is where it gets fun
        NSError* error;
        PickySearchOperation* operation = [PickySearchOperation operationWithUrlAndParams:url params:params error:error];
        
        // Let's make sure we catch the completion block so we can verify the results
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id json) {
            dispatch_async(dispatch_get_main_queue(), ^{
                itShouldBehaveLike(SHARED_PARSE_MULTIPLE_ALLOCATIONS, @{@"json" : json});
            });
            done ();
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // Something went wrong, and we don't want that
                expect(error).will.beNil();
            });
            done ();
        }];
        
        // Let's make the request
        [_queue addOperation:operation];
        
        // Make sure we're error-free
        expect(error).to.beNil();
    });
});

SpecEnd
