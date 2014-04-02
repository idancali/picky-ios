//
// PickyExample.m
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


#import "PickyExample.h"
#import "Picky.h"
#import "PickySearchOperation.h"

@implementation PickyExample

/**
  Here's a simple example to test out your Picky client.
  For the purpose of this sample, we're using the CocoaPods search API:
  http://blog.cocoapods.org/Search-API-Version-1/
 **/
- (void) performPickySearchForPods
{
    NSError* error;
    NSString* url = @"http://search.cocoapods.org/api/pods";
    NSDictionary* params = @{@"query" : @"test", @"start-at" : @"50", @"amount" : @"100"};
    
    PickySearchOperation* operation = [PickySearchOperation operationWithUrlAndParams:url params:params error:error];
    [operation search:^(Picky* result)
    {
        NSLog(@"Got %d Picky results at offset %d in %f seconds", result.total, result.offset, result.duration);
    }
    failure:^(NSString* errorMessage)
    {
        NSLog(@"Picky Error: %@", errorMessage);
    }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // Sample search
    [self performPickySearchForPods];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
