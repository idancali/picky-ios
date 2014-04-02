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

#import "Picky.h"
#import "PickySearchOperation.h"

#define SHARED_PARSE_MULTIPLE_ALLOCATIONS   @"parse multiple allocations"
#define SHARED_PARSE_SINGLE_ALLOCATION      @"parse one allocation"

SharedExamplesBegin(Picky)

// This scenario checks if our code can handle a single allocation
sharedExamplesFor(SHARED_PARSE_SINGLE_ALLOCATION, ^(NSDictionary* data ) {

    // Let's start by making sure the data is valid
    id json = [data objectForKey:@"json"];
    expect(json).toNot.beNil();

    // Let's check if the initial parsing passed
    Picky* picky = [Picky pickyWithJson:json];
    expect(picky).toNot.beNil();

    // The test results we are expecting are for a single result at offset 0 and with the given duration of 0.000259
    expect(picky.offset).to.equal(0);
    expect(picky.total).to.equal(1);
    expect(picky.duration).to.equal(0.000259);

    // We have to make sure we found exactly one allocation
    expect(picky.allocations).toNot.beNil();
    expect([picky.allocations count]).to.equal(1);

    // Let's make sure that allocation parses ok
    PickyAllocation* allocation = [picky.allocations firstObject];
    expect(allocation).toNot.beNil();

    // The index name we expect is 'pods', with a 6.0 score and with one single result
    expect(allocation.indexName).to.equal(@"pods");
    expect(allocation.score).to.equal(3.0f);
    expect(allocation.totalResults).to.equal(1);

    // We expect one single match result
    expect(allocation.matches).toNot.beNil();
    expect(allocation.matches.count).to.equal(1);

    // We expect one single id
    expect(allocation.resultIds).toNot.beNil();
    expect(allocation.resultIds.count).to.equal(1);

    // Let's just make sure we do have one result though
    expect(allocation.results).toNot.beNil();
    expect(allocation.results.count).to.equal(1);
});

// This scenario checks if our code can handle a multiple allocations
sharedExamplesFor(SHARED_PARSE_MULTIPLE_ALLOCATIONS, ^(NSDictionary* data) {

    // Let's start by making sure the data is valid
    id json = [data objectForKey:@"json"];
    expect(json).toNot.beNil();

    // Let's check if the initial parsing passed
    Picky* picky = [Picky pickyWithJson:json];
    expect(picky).toNot.beNil();

    // The test results we are expecting are for 2 allocations at offset 0 and with the given duration of 0.000216
    expect(picky.offset).to.equal(0);
    expect(picky.total).to.equal(2);
    expect(picky.duration).to.equal(0.000216);

    // We have to make sure we found exactly 2 allocations
    expect(picky.allocations).toNot.beNil();
    expect([picky.allocations count]).to.equal(2);

    // Let's make sure that the first allocation parses ok
    PickyAllocation* firstAllocation = [picky.allocations firstObject];
    expect(firstAllocation).toNot.beNil();
    expect(firstAllocation.indexName).to.equal(@"pods");
    expect(firstAllocation.score).to.equal(3.0f);
    expect(firstAllocation.totalResults).to.equal(1);
    expect(firstAllocation.matches).toNot.beNil();
    expect(firstAllocation.matches.count).to.equal(1);
    expect(firstAllocation.resultIds).toNot.beNil();
    expect(firstAllocation.resultIds.count).to.equal(1);
    expect(firstAllocation.results).toNot.beNil();
    expect(firstAllocation.results.count).to.equal(1);

    // Now's let check the second allocation
    PickyAllocation* secondAllocation = [picky.allocations lastObject];
    expect(secondAllocation).toNot.beNil();
    expect(secondAllocation.indexName).to.equal(@"pods");
    expect(secondAllocation.score).to.equal(-3.0f);
    expect(secondAllocation.totalResults).to.equal(1);
    expect(secondAllocation.matches).toNot.beNil();
    expect(secondAllocation.matches.count).to.equal(1);
    expect(secondAllocation.resultIds).toNot.beNil();
    expect(secondAllocation.resultIds.count).to.equal(1);
    expect(secondAllocation.results).toNot.beNil();
    expect(secondAllocation.results.count).to.equal(1);
});

SharedExamplesEnd

SpecBegin(Picky)

// We want to handle Picky search results, so let's check for search result scenarios
describe(@"Search", ^{

    // We're going to use this queue to test our scenario async operations
    __block NSOperationQueue* _queue    =   nil;

    // This is our test bundle that's we're going to use to store test resources for all of our scenarios
    __block NSBundle* _bundle           =   nil;

    // These are simple helper blocks that allow us to neatly store expected JSON results in test files in our test bundle
    __block NSString* (^loadFileContent)(NSString* filename) = ^(NSString* filename){return [NSString stringWithContentsOfFile:[_bundle pathForResource:filename ofType:@"json"] encoding:NSUTF8StringEncoding error:NULL];};
    __block id (^loadExpectedJsonResultFromFile)(NSString* filename) = ^(NSString* filename){return
        [NSJSONSerialization JSONObjectWithData:[loadFileContent(filename) dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];};
    
    beforeAll(^{
        // We're only going to do this once, and we're going to re-use the bundle for all scenarios
        _bundle          = [NSBundle bundleForClass:[self class]];
        
        // We're only going to setup a queue once
        _queue           = [[NSOperationQueue alloc] init];
        
        // Let's start stubbing calls; we're not interested in testing networking
        [[LSNocilla sharedInstance] start];
        [Expecta setAsynchronousTestTimeout:5.0];
    });
    
    afterAll(^{
        // We can now stop stubbing request
        [[LSNocilla sharedInstance] stop];
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
    // We're going to use the CocoaPods API as our reference point: http://blog.cocoapods.org/Search-API-Version-1/
    it (@"Can perform search operations", ^AsyncBlock {
       
        // Here's the request we're checking: http://search.cocoapods.org/api/pods?query=sdl&amount=2&start-at=0
        NSString* url = @"http://search.cocoapods.org/api/pods";
        NSDictionary* params = @{@"query" : @"sdl", @"start-at" : @"0", @"amount" : @"2"};
        NSString* expectedJsonResponse = (NSString*) loadFileContent(@"multiple-allocations-search");

        // Our purpose is to verify our flow, not to test networking so let's stub out the call for now
        stubRequest(@"GET", @"http://search.cocoapods.org/api/pods?amount=2&query=sdl&start-at=0").andReturn(200).
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
