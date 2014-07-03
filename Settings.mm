#include "Settings.h"

settings jetpackSettings("/var/mobile/Library/Preferences/jetpack.plist");
const char *path;
int settings::GetPrefInt(const char* key)
{
	return [[[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithUTF8String:path]] valueForKey:[NSString stringWithUTF8String:key]] intValue];
}

float settings::GetPrefFloat(const char* key)
{
	return [[[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithUTF8String:path]] valueForKey:[NSString stringWithUTF8String:key]] floatValue];
}

bool settings::GetPrefBool(const char* key) 
{
	return [[[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithUTF8String:path]] valueForKey:[NSString stringWithUTF8String:key]] boolValue];
}

void settings::settings_proxy::set(bool value)
{
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithUTF8String:path]];
	NSNumber *val = [NSNumber numberWithBool:value];
	[dict setValue:val forKey:[NSString stringWithUTF8String:path]];
	[dict writeToFile: [NSString stringWithUTF8String:path] atomically: YES];
}

void settings::settings_proxy::set(int value)
{
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithUTF8String:path]];
	NSNumber *val = [NSNumber numberWithInt:value];
	[dict setValue:val forKey:[NSString stringWithUTF8String:path]];
	[dict writeToFile: [NSString stringWithUTF8String:path] atomically: YES];
}

void settings::settings_proxy::set(float value)
{
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithUTF8String:path]];
	NSNumber *val = [NSNumber numberWithFloat:value];
	[dict setValue:val forKey:[NSString stringWithUTF8String:path]];
	[dict writeToFile: [NSString stringWithUTF8String:path] atomically: YES];
}
