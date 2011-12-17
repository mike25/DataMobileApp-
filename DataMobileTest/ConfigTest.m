
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
    [Config loadForFileName:@"config-test"];
}

-(void)testDictionnaryIsLoaded
{
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
    
    NSUInteger size = 2 ;
    STAssertEquals([[instance configs] count], size, @"The number of entries found in the config file is not the one expected");
}

- (void)testValuesForKeys
{
    NSString* value1 = (NSString*)[[Config instance] valueForKey:@"key1"];
    STAssertEqualObjects(value1, @"value1", @"value for key1 is not the one expected");

    NSString* value2 = (NSString*)[[Config instance] valueForKey:@"anotherKey"];
    int int_value2 = [value2 intValue];
    STAssertEquals(int_value2, 999, @"value for anotherKey is not the one expected");
    
    STAssertNil([[Config instance] valueForKey:@"insertLocationUrl"], @"the dico has one key that should not be there");
}

@end
