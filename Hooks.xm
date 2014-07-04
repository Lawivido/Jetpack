/*
Jetpack Cheats
By: Lawivido/Razzile
Credit Due: AlphaMatter 
File: Hooks.mm
*/
#include <substrate.h>
#include "Settings.h"

float (*old_missileSpeed)(void *self, unsigned long speed);
bool (*old_autoCoins)(void *self, void *game);
bool (*old_autoVehicle)(void *self, void *game);
bool (*old_autoToken)(void *self, void *game);
bool (*old_dumbLazer)(void *self,void *game);
bool (*old_dumbMissile)(void *self, void *game);
void (*old_dumbMissileBot)(void *self);
bool (*old_dumbGates)(void *self, void *game);
bool (*old_boostHeadstart2)(void *self);

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

bool dumbGates(void *self, void *game) {
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

%ctor 
{
	MSHookFunction((void*)(0x12CF0+1),(void *)autoCoins,(void**)&old_autoCoins);
	MSHookFunction((void*)(0x897E8+1),(void *)autoVehicle,(void**)&old_autoVehicle);
	MSHookFunction((void*)(0x9C928+1),(void *)autoToken,(void**)&old_autoToken);
	MSHookFunction((void*)(0x161C8+1),(void *)dumbLazer,(void**)&old_dumbLazer);
	MSHookFunction((void*)(0x154AF8+1),(void *)dumbMissile,(void**)&old_dumbMissile);
	MSHookFunction((void*)(0x1BB38+1),(void *)dumbGates,(void**)&old_dumbGates);
	//MSHookFunction((void*)(0x15494C+1),(void *)dumbMissileBot,(void**)&old_dumbMissileBot);
	MSHookFunction((void*)(0x5CA68+1),(void *)missileSpeed,(void**)&old_missileSpeed);
}
