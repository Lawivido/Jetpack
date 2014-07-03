/*
Jetpack Cheats
By: Lawivido/Razzile
Credit Due: AlphaMatter 
File: Settings.h
*/

#include <iostream>
#include <string>
#include <Foundation/Foundation.h>

extern const char *path;
#define Settings(p) const char* path = p; settings

using namespace std;

class settings {
public:

	static int GetPrefInt(const char* key);
	static bool GetPrefBool(const char* key);

	class settings_proxy {
	public:
		const char* key;

		settings_proxy(const char* _key) {
			key = _key;
		 }

		 __attribute__((noinline))
		operator int() {
			return settings::GetPrefInt(key);
		}

		 __attribute__((noinline))
		operator float() {
			return settings::GetPrefFloat(key);
		}

		__attribute__((noinline))
		operator bool() {
			return settings::GetPrefBool(key);
		}
		void set(bool value);
		void set(int value);
		void set(float value);

	};
	__attribute__((noinline))
	settings_proxy operator[] (const char* key) {
		settings_proxy proxy(key);
		return proxy;
	}

};

int settings::GetPrefInt(const char* key)
{
	return [[[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithUTF8String:path]] valueForKey:[NSString stringWithUTF8String:key]] intValue];
}

int settings::GetPrefFloat(const char* key)
{
	return [[[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithUTF8String:path]] valueForKey:[NSString stringWithUTF8String:key]] floatValue];
}

bool settings::GetPrefBool(const char* key) 
{
	return [[[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithUTF8String:path]] valueForKey:[NSString stringWithUTF8String:key]] boolValue];
}

void settings_proxy::set(bool value)
{
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithUTF8String:path]];
	NSNumber *val = [NSNumber numberWithBool:value];
	[dict setValue:val forKey:[NSString stringWithUTF8String:path]];
	[dict writeToFile: filepath atomically: YES];
}

void settings_proxy::set(int value)
{
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithUTF8String:path]];
	NSNumber *val = [NSNumber numberWithInt:value];
	[dict setValue:val forKey:[NSString stringWithUTF8String:path]];
	[dict writeToFile: filepath atomically: YES];
}

void settings_proxy::set(float value)
{
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithUTF8String:path]];
	NSNumber *val = [NSNumber numberWithFloat:value];
	[dict setValue:val forKey:[NSString stringWithUTF8String:path]];
	[dict writeToFile: filepath atomically: YES];
}

Settings("/var/mobile/Library/Preferences/jetpack.plist") jetpackSettings;