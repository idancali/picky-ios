Picky iOS SDK
=========

[Picky](https://github.com/floere/picky) is lightweight semantic text search engine. The Picky iOS SDK enables your iOS app to talk to a Picky server and to easily perform search operations.

### Getting Started

The Picky iOS SDK is a breeze to setup and use. All you need to do is add the kit to your app, include the header in your code
and perform a search operation. That's it.

#### Add via CocoaPods

```ruby
platform :ios, '7.0'
pod "Picky", "~> 0.1.0"
```

####  Import the SDK into your code

```objective-c
#import "Picky.h"
```

#### Perform a search operation

```objective-c
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
```

### Sample app

A very simple sample app is included in the code, that performs a simple search
operation on the [CocoaPods API](http://blog.cocoapods.org/Search-API-Version-1/).

- Open the Picky.xcworkspace
- Run the PickyExample application by executing the Picky target (⌘+R)
- The sample app will perform the following search:

   ```ruby
   GET http://search.cocoapods.org/api/pods?query=test&amount=100&start-at=50
   ```

- You should be getting a successful prompt on the console:

   ```ruby
   2014-04-02 23:39:20.650 Picky[7381:a0b] Got 137 Picky results at offset 50 in 0.000233 seconds
   ```

### Acceptance Testing

The code was tested against an initial behaviour-driven specification that
verifies the Picky JSON parsing as well as the search operation functionality.

- Open the Picky.xcworkspace
- Run the PickySpec specification by executing the PickyTests target (⌘+U)
- All 3 tests should pass successfully

   ```ruby
   Executed 3 tests, with 0 failures (0 unexpected) in 0.339 (0.341) seconds
   ```
 
### License

The Picky iOS SDK is made available under the MIT license. Pleace see the LICENSE file 
for more details.

