//
// PickySharedSpec.m
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

#import "Picky.h"

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
    
    // The test results we are expecting are for a single result at offset 0 and with the given duration of 0.001214
    expect(picky.offset).to.equal(0);
    expect(picky.total).to.equal(1);
    expect(picky.duration).to.equal(0.001214);
    
    // We have to make sure we found exactly one allocation
    expect(picky.allocations).toNot.beNil();
    expect([picky.allocations count]).to.equal(1);
    
    // Let's make sure that allocation parses ok
    PickyAllocation* allocation = [picky.allocations firstObject];
    expect(allocation).toNot.beNil();
    
    // The index name we expect is 'books', with a 6.0 score and with one single result
    expect(allocation.indexName).to.equal(@"books");
    expect(allocation.score).to.equal(6.0f);
    expect(allocation.totalResults).to.equal(1);
    
    // We expect one single match result
    expect(allocation.matches).toNot.beNil();
    expect(allocation.matches.count).to.equal(1);
    
    // We don't care about id's right now
    expect(allocation.resultIds).toNot.beNil();
    expect(allocation.resultIds.count).to.equal(0);
    
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
    
    // The test results we are expecting are for 3 allocations at offset 0 and with the given duration of 0.000162
    expect(picky.offset).to.equal(0);
    expect(picky.total).to.equal(3);
    expect(picky.duration).to.equal(0.000162);
    
    // We have to make sure we found exactly 2 allocations
    expect(picky.allocations).toNot.beNil();
    expect([picky.allocations count]).to.equal(2);
    
    // Let's make sure that the first allocation parses ok
    PickyAllocation* firstAllocation = [picky.allocations firstObject];
    expect(firstAllocation).toNot.beNil();
    expect(firstAllocation.indexName).to.equal(@"books");
    expect(firstAllocation.score).to.equal(6.0f);
    expect(firstAllocation.totalResults).to.equal(1);
    expect(firstAllocation.matches).toNot.beNil();
    expect(firstAllocation.matches.count).to.equal(1);
    expect(firstAllocation.resultIds).toNot.beNil();
    expect(firstAllocation.resultIds.count).to.equal(0);
    expect(firstAllocation.results).toNot.beNil();
    expect(firstAllocation.results.count).to.equal(1);
    
    // Now's let check the second allocation
    PickyAllocation* secondAllocation = [picky.allocations lastObject];
    expect(secondAllocation).toNot.beNil();
    expect(secondAllocation.indexName).to.equal(@"books");
    expect(secondAllocation.score).to.equal(0.69f);
    expect(secondAllocation.totalResults).to.equal(2);
    expect(secondAllocation.matches).toNot.beNil();
    expect(secondAllocation.matches.count).to.equal(1);
    expect(secondAllocation.resultIds).toNot.beNil();
    expect(secondAllocation.resultIds.count).to.equal(0);
    expect(secondAllocation.results).toNot.beNil();
    expect(secondAllocation.results.count).to.equal(2);
});

SharedExamplesEnd

