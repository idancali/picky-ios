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

### License

The Picky iOS SDK is made available under the MIT license. Pleace see the LICENSE file 
for more details.

