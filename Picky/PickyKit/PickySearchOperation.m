//
// PickySearchOperation.m
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

#import "PickySearchOperation.h"
#import "AFNetworking.h"

@implementation PickySearchOperation

+ (PickySearchOperation*) operationWithUrlAndParams: (NSString*) url params: (NSDictionary*) params error: (NSError*) error
{
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:url parameters:params error:&error];
    PickySearchOperation* operation = [[PickySearchOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    return operation;
}

- (void) search: (void (^)(Picky* result)) success failure: (void (^)(NSString* errorMessage)) failure
{
    [self setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id json) {
        success ([Picky pickyWithJson:json]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure ([error localizedDescription]);
    }];
    [[NSOperationQueue mainQueue] addOperation:self];
}


@end
