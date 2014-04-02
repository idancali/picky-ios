//
// PickyAllocation.m
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

#import "PickyAllocation.h"

@implementation PickyAllocation

@synthesize indexName           = _indexName;
@synthesize score               = _score;
@synthesize totalResults        = _totalResults;
@synthesize resultIds           = _resultIds;
@synthesize results             = _results;
@synthesize matches             = _matches;

+ (PickyAllocation*) allocationWithJson: (id) json
{
    if (json == nil || ![json isKindOfClass:[NSArray class]])
    {
        // We expect a valid JSON representing an array object; nothing else will do
        return nil;
    }
    
    NSArray* elements = (NSArray*) json;
    
    if ([elements count] < 6)
    {
        // Each Picky allocation is expected to contain exactly 6 elements
        return nil;
    }
    
    id indexName = [elements objectAtIndex:0];

    if (indexName == nil || ![indexName isKindOfClass:[NSString class]])
    {
        // The index is the first element and it must be a string
        return nil;
    }
    
    id score = [elements objectAtIndex:1];

    if (score == nil || ![score isKindOfClass:[NSNumber class]])
    {
        // Next comes the score, and we expect this to be a number
        return nil;
    }

    id numResults = [elements objectAtIndex:2];
    
    if (numResults == nil || ![numResults isKindOfClass:[NSNumber class]])
    {
        // The third value we expect is the score, and we expect this to be a number too
        return nil;
    }
    
    id matchesData = [elements objectAtIndex:3];

    if (matchesData == nil || ![matchesData isKindOfClass:[NSArray class]])
    {
        // The last three elements are all arrays; this first array represents the matches found
        return nil;
    }

    id idsData = [elements objectAtIndex:4];
    
    if (idsData == nil || ![idsData isKindOfClass:[NSArray class]])
    {
        // The second array we expect represents the ID's of the results found
        return nil;
    }
    
    id resultsData = [elements objectAtIndex:5];
    
    if (resultsData == nil || ![resultsData isKindOfClass:[NSArray class]])
    {
        // And finally, we expect the actuall results found as an array at the end of the allocation
        return nil;
    }

    // We're good to go, let's construct the allocation
    PickyAllocation* instance   = [[PickyAllocation alloc] init];
    instance.indexName          = indexName;
    instance.score              = [score floatValue];
    instance.totalResults       = [numResults integerValue];
    instance.matches            = [NSArray arrayWithArray:matchesData];
    instance.resultIds          = [NSArray arrayWithArray:idsData];
    instance.results            = [NSArray arrayWithArray:resultsData];
    
    return instance;
}

@end
