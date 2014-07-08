/*
Jetpack Cheats
By: Lawivido/Razzile
Credit Due: AlphaMatter 
File: Hooks.mm
*/
#include <substrate.h>
#include "Settings.h"

#define BLACK_COLOR (void *)0x7E84C0
#define WHITE_COLOR (void *)0x7E84C4
#define RED_COLOR (void *)0x7E84C8
#define GREEN_COLOR (void *)0x7E84CC
#define BLUE_COLOR (void *)0x7E84D0
#define YELLOW_COLOR (void *)0x7E84D4
#define MAGENTA_COLOR (void *)0x7E84D8
#define CYAN_COLOR (void *)0x7E84DC

float (*old_missileSpeed)(void *ptr, unsigned long speed);
int (*old_GetCurrencyQty)(void*, const char*);
bool (*old_autoCoins)(void *ptr, void *game, bool &unk1);
bool (*old_autoVehicle)(void *ptr, void *game);
bool (*old_autoToken)(void *ptr, void *game);
bool (*old_dumbLazer)(void *ptr,void *game);
bool (*old_dumbMissile)(void *ptr, void *game);
void (*old_dumbMissileBot)(void *ptr);
bool (*old_dumbGates)(void *ptr, void *game);
bool (*old_boostHeadstart2)(void *ptr);
void (*Missile_Kill)(void *ptr);
void (*Missile_Destroy)(void *ptr);
void (*old_CreditsView_InsertItem)(void *ptr, const char *item, void *color);

//------
//Coins
//------

int GetCurrencyQty(void *self, const char* bundle)
{
	bool currency = jetpackSettings["kCurrency"];
	if(currency)
	{
		return 99999999;
	}
	return old_GetCurrencyQty(self, bundle);
}

bool autoCoins(void *ptr, void *game, bool &unk1) {
	bool coins = jetpackSettings["kCoins"];
	if(coins)
	{
		return true;
	}
	return old_autoCoins(ptr, game, unk1);
}

bool autoVehicle(void *ptr, void* game) {
	bool vehicle = jetpackSettings["kVehicle"];
	if(vehicle)
	{
		return true;
	}
	return old_autoVehicle(ptr, game);
}

bool autoToken(void *ptr, void *game) {
	bool token = jetpackSettings["kTokens"];
	if(token)
	{
		return true;
	}
	return old_autoToken(ptr, game);
}

bool dumbLazer(void *ptr, void *game) {
	bool invincibility = jetpackSettings["kInvincibility"];
	if(invincibility)
	{
		return false;
	}
	return old_dumbLazer(ptr, game);	
}

bool dumbMissile(void *ptr, void *game) {
	bool invincibility = jetpackSettings["kInvincibility"];
	if(invincibility)
	{
		Missile_Kill(ptr);
		Missile_Destroy(ptr);
		return false;
	}
	return old_dumbMissile(ptr, game);
}

bool dumbGates(void *ptr, void *game) {
	bool invincibility = jetpackSettings["kInvincibility"];
	if(invincibility)
	{
		return false;
	}
	return old_dumbGates(ptr, game);
}

void dumbMissileBot(void *ptr) {
}

float missileSpeed(void *ptr, unsigned long speed) {
	return jetpackSettings["kMissile"];
}

void CreditsView_InsertItem(void *self, const char *item, void *color) {
	if (strcmp("Developers:",item) == 0) {
		old_CreditsView_InsertItem(self,"Cheaters:",MAGENTA_COLOR);
		old_CreditsView_InsertItem(self,"DRM",RED_COLOR);
		old_CreditsView_InsertItem(self,"Lawivido",RED_COLOR);
		old_CreditsView_InsertItem(self,"Razzile",RED_COLOR);
		old_CreditsView_InsertItem(self,"Visit iOSCheaters.com",CYAN_COLOR);
		old_CreditsView_InsertItem(self,"",WHITE_COLOR);
	}
	old_CreditsView_InsertItem(self,item,color);
	}

%ctor 
{
	MSHookFunction((void*)(0x12CF0+1),(void *)autoCoins,(void**)&old_autoCoins);
	MSHookFunction((void*)(0x128C08+1), (void*)GetCurrencyQty, (void**)&old_GetCurrencyQty);
	MSHookFunction((void*)(0x897E8+1),(void *)autoVehicle,(void**)&old_autoVehicle);
	MSHookFunction((void*)(0x9C928+1),(void *)autoToken,(void**)&old_autoToken);
	MSHookFunction((void*)(0x161C8+1),(void *)dumbLazer,(void**)&old_dumbLazer);
	MSHookFunction((void*)(0x154AF8+1),(void *)dumbMissile,(void**)&old_dumbMissile);
	MSHookFunction((void*)(0x1BB38+1),(void *)dumbGates,(void**)&old_dumbGates);
	MSHookFunction((void*)(0x5CA68+1),(void *)missileSpeed,(void**)&old_missileSpeed);
	MSHookFunction((void*)(0xB2BF8+1),(void *)CreditsView_InsertItem,(void**)&old_CreditsView_InsertItem);

	Missile_Kill = (void (*)(void*))(0x1559F0+1);
	Missile_Destroy = (void (*)(void*))(0x1537C8+1);
}
