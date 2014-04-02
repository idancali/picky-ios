//
// Picky.h
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

/**
 A `Picky` instance represents an hash as described in the Picky format:
 https://github.com/floere/picky/wiki/Results-format-and-structure#the-structure

 Picky is a lightweight semantic text search engine for categorized data.
 More details about Picky here: http://florianhanke.com/picky/
 **/
@interface Picky : NSObject

@property (nonatomic) int offset;
@property (nonatomic) int total;
@property (nonatomic) double duration;
@property (nonatomic) NSArray* allocations;

/**
 Given a JSON object, creates a `Picky` instance; returns `nil` if the JSON could not be parsed
 
 @param a JSON object
 @return a `Picky` instance or `nil` if the JSON could not be parsed
 */
+ (Picky*) pickyWithJson: (id) json;

@end
