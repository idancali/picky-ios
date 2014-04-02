//
// Picky.m
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

#import "Picky.h"

@implementation Picky

@synthesize offset          = _offset;
@synthesize total           = _total;
@synthesize duration        = _duration;

+ (Picky*) pickyWithJson: (id) json
{
    if (json == nil || ![json isKindOfClass:[NSDictionary class]])
    {
        // We expect a valid JSON representing a dictionary object; nothing else will do
        return nil;
    }
    
    id offset = [json objectForKey:@"offset"];
    
    if (offset == nil || ![offset isKindOfClass:[NSNumber class]])
    {
        // The first value we expect is a number representing the offset of the search results returned
        return nil;
    }
    
    id total = [json objectForKey:@"total"];
    
    if (total == nil || ![total isKindOfClass:[NSNumber class]])
    {
        // The next value we expect is also a number, and it represents the total amount of search results returned
        return nil;
    }

    id duration = [json objectForKey:@"duration"];
    
    if (duration == nil || ![duration isKindOfClass:[NSNumber class]])
    {
        // The third value is also a number, and it represents the time it took the Picky server to find the results
        return nil;
    }

    id allocationsData = [json objectForKey:@"allocations"];
    
    if (allocationsData == nil || ![allocationsData isKindOfClass:[NSArray class]])
    {
        // Next, we expect the actual allocations, returned as an array
        return nil;
    }
    
    // Ok we've got everything we need, but let's make sure the allocations are valid too, so let's parse those now
    NSMutableArray* allocations = [NSMutableArray array];
    
    for (id allocationJson in allocationsData)
    {
        // This will give us an actual allocation object, if everything is ok
        PickyAllocation* allocation = [PickyAllocation allocationWithJson:allocationJson];
        
        if (allocation == nil)
        {
            // Looks like this allocation is invalid, so we want to completely bail out now
            return nil;
        }
        
        // Good, we've got a valid allocation, let's keep track of it
        [allocations addObject:allocation];
    }
    
    // We're good to go, let's construct the actual Picky hash
    Picky* instance         = [[Picky alloc] init];
    instance.offset         = [offset integerValue];
    instance.total          = [total integerValue];
    instance.duration       = [duration doubleValue];
    instance.allocations    = [NSArray arrayWithArray:allocations];
    
    return instance;
}

@end
