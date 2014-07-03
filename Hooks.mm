/*
Jetpack Cheats
By: Lawivido/Razzile
Credit Due: AlphaMatter 
File: Hooks.mm
*/

#include "Hooks.h"
#include "Settings.h"


//------
//Coins
//------

bool autoCoins(void *self, void *game) {
	bool coins = jetpackSettings["kCoins"];
	if(coins)
	{
		return true;
	}
	return old_autoCoins(self, game);
}

bool autoVehicle(void *self, void* game) {
	bool vehicle = jetpackSettings["kVehicle"];
	if(vehicle)
	{
		return true;
	}
	return old_autoVehicle(self, game);
}

bool autoToken(void *self, void *game) {
	bool token = jetpackSettings["kTokens"];
	if(token)
	{
		return true;
	}
	return old_autoToken(self, game);
}

bool dumbLazer(void *self, void *game) {
	bool invincibility = jetpackSettings["kInvincibility"];
	if(invincibility)
	{
		return false;
	}
	return old_dumbLazer(self, game);	
}

bool dumbMissile(void *self, void *game) {
	bool invincibility = jetpackSettings["kInvincibility"];
	if(invincibility)
	{
		return false;
	}
	return old_dumbMissile(self, game);
}

bool dumbGates(void *self, bool dumb) {
	bool invincibility = jetpackSettings["kInvincibility"];
	if(invincibility)
	{
		return false;
	}
	return old_dumbGates(self, game);
}

void dumbMissileBot(void *self) {
}

float missileSpeed(void *self, unsigned long speed) {
	return jetpackSettings["kMissile"];
}
