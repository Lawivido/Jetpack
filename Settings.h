/*
Jetpack Cheats
By: Lawivido/Razzile
Credit Due: AlphaMatter 
File: Settings.h
*/

#ifndef __Settings__
#define __Settings__

#include <iostream>
#include <string>
#include <Foundation/Foundation.h>

extern const char *path;
#define Settings(p) const char* path = p; settings

using namespace std;

class settings {
public:
	settings(const char *_path) { path = _path; }
	static int GetPrefInt(const char* key);
	static float GetPrefFloat(const char* key);
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

extern settings jetpackSettings;
#endif
