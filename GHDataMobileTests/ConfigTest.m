
#import "ConfigTest.h"
#import "Config.h"

#import <UIKit/UIKit.h>

@implementation ConfigTest

- (void)testAppDelegate
{
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
}

- (void)setUp 
{
    STAssertNotNil([Config loadForFileName:@"config"], @"instance has not been initialized");
}

-(void)testDictionnaryIsLoaded
{
    [Config loadForFileName:@"config"];
    STAssertNotNil([[Config instance] configs], @"dictionnary is not loaded");
}

- (void)testInstanceIsUnique
{
    Config* instance1 = [Config instance];
    Config* instance2 = [Config instance];
    Config* instance3 = [Config instance];
    
    STAssertNotNil(instance1, @"");
    STAssertEquals(instance1, instance2, @"Config returns more than one instance.");
    STAssertEquals(instance2, instance3, @"Config returns more than one instance.");
}

- (void)testDicoIsFilled
{
    Config* instance = [Config instance];
    STAssertNotNil([instance configs] , @"no dictionnary is found");
    
    NSUInteger size = 4 ;
    STAssertEquals([[instance configs] count], size, @"The number of entries found in the config file is not the one expected");
}

- (void)testValuesForKeys
{
    NSString* value1 = [[Config instance] stringValueForKey:@"key1"];
    STAssertEqualObjects(value1, @"value1", @"value for key1 is not the one expected");
    
    int value2 = [[Config instance] integerValueForKey:@"anotherKey"]; 
    STAssertEquals(value2, 999, @"value for anotherKey is not the one expected");
    
    STAssertNil([[Config instance] valueForKey:@"insertLocationUrl"], @"the dico has one key that should not be there");
}

@end
