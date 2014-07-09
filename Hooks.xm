/*
Jetpack Cheats
By: Lawivido/Razzile
Credit Due: AlphaMatter 
File: Hooks.mm
*/
#include <substrate.h>
#include "Settings.h"

#define BLACK_COLOR (void*)0x7E84C0
#define WHITE_COLOR (void*)0x7E84C4
#define RED_COLOR (void*)0x7E84C8
#define GREEN_COLOR (void*)0x7E84CC
#define BLUE_COLOR (void*)0x7E84D0
#define YELLOW_COLOR (void*)0x7E84D4
#define MAGENTA_COLOR (void*)0x7E84D8
#define CYAN_COLOR (void*)0x7E84DC

float* CURRENT_LEVEL_VELOCITY = (float*)0x7C22AC;

float (*old_missileSpeed)(void *ptr, unsigned long speed);
int (*old_GetCurrencyQty)(void*, const char*);
bool (*old_Coin_CollidingWithPlayer)(void *ptr, void *game, bool &unk1);
bool (*old_Vehicle_CollidingWithPlayer)(void *ptr, void *game);
bool (*old_Token_CollidingWithPlayer)(void *ptr, void *game);
bool (*old_Lazer_CollidingWithPlayer)(void *ptr,void *game);
bool (*old_Missile_CollidingWithPlayer)(void *ptr, void *game);
void (*old_Missile_CollidingWithPlayerBot)(void *ptr);
bool (*old_Gate_CollidingWithPlayer)(void *ptr, void *game);
void (*old_Player_Update)(void *ptr, void *game);
void (*old_CreditsView_InsertItem)(void *ptr, const char *item, void *color);
void (*Missile_Kill)(void *ptr);
void (*Missile_Destroy)(void *ptr);
bool (*Player_IsDead)(void *ptr);
//------
//Coins
//------

int GetCurrencyQty(void *ptr, const char* bundle)
{
	bool currency = jetpackSettings["kCurrency"];
	if(currency)
	{
		return 99999999;
	}
	return old_GetCurrencyQty(ptr, bundle);
}

bool Coin_CollidingWithPlayer(void *ptr, void *game, bool &unk1) {
	bool coins = jetpackSettings["kCoins"];
	if(coins)
	{
		return true;
	}
	return old_Coin_CollidingWithPlayer(ptr, game, unk1);
}

bool Vehicle_CollidingWithPlayer(void *ptr, void* game) {
	bool vehicle = jetpackSettings["kVehicle"];
	if(vehicle)
	{
		return true;
	}
	return old_Vehicle_CollidingWithPlayer(ptr, game);
}

bool Token_CollidingWithPlayer(void *ptr, void *game) {
	bool token = jetpackSettings["kTokens"];
	if(token)
	{
		return true;
	}
	return old_Token_CollidingWithPlayer(ptr, game);
}

bool Lazer_CollidingWithPlayer(void *ptr, void *game) {
	bool invincibility = jetpackSettings["kInvincibility"];
	if(invincibility)
	{
		return false;
	}
	return old_Lazer_CollidingWithPlayer(ptr, game);	
}

bool Missile_CollidingWithPlayer(void *ptr, void *game) {
	bool invincibility = jetpackSettings["kInvincibility"];
	if(invincibility)
	{
		if(old_Missile_CollidingWithPlayer(ptr, game))
		{
			Missile_Kill(ptr);
			Missile_Destroy(ptr);
			return false;
		}
	}
	return old_Missile_CollidingWithPlayer(ptr, game);
}

bool Gate_CollidingWithPlayer(void *ptr, void *game) {
	bool invincibility = jetpackSettings["kInvincibility"];
	if(invincibility)
	{
		return false;
	}
	return old_Gate_CollidingWithPlayer(ptr, game);
}

void Missile_CollidingWithPlayerBot(void *ptr) {
}

float missileSpeed(void *ptr, unsigned long speed) {
	return jetpackSettings["kMissile"];
}

void Player_Update(void *ptr, void *game)
{
	if(!Player_IsDead(ptr))
	{
		*CURRENT_LEVEL_VELOCITY = jetpackSettings["kSpeed"];
	}
	return old_Player_Update(ptr, game);
}

void CreditsView_InsertItem(void *ptr, const char *item, void *color) {
	if (strcmp("Developers:",item) == 0) {
		old_CreditsView_InsertItem(ptr,"Cheaters:",YELLOW_COLOR);
		old_CreditsView_InsertItem(ptr,"Razzile",WHITE_COLOR);
		old_CreditsView_InsertItem(ptr,"Lawivido",WHITE_COLOR);
		old_CreditsView_InsertItem(ptr,"DRM",WHITE_COLOR);
		old_CreditsView_InsertItem(ptr,"Visit iOSCheaters.com",CYAN_COLOR);
		old_CreditsView_InsertItem(ptr,"",WHITE_COLOR);
	}
	old_CreditsView_InsertItem(ptr,item,color);
}

%ctor 
{
	MSHookFunction((void*)(0x12CF0+1),(void *)Coin_CollidingWithPlayer,(void**)&old_Coin_CollidingWithPlayer);
	MSHookFunction((void*)(0x128C08+1),(void*)GetCurrencyQty,(void**)&old_GetCurrencyQty);
	MSHookFunction((void*)(0x897E8+1),(void *)Vehicle_CollidingWithPlayer,(void**)&old_Vehicle_CollidingWithPlayer);
	MSHookFunction((void*)(0x9C928+1),(void *)Token_CollidingWithPlayer,(void**)&old_Token_CollidingWithPlayer);
	MSHookFunction((void*)(0x161C8+1),(void *)Lazer_CollidingWithPlayer,(void**)&old_Lazer_CollidingWithPlayer);
	MSHookFunction((void*)(0x154AF8+1),(void *)Missile_CollidingWithPlayer,(void**)&old_Missile_CollidingWithPlayer);
	MSHookFunction((void*)(0x1BB38+1),(void *)Gate_CollidingWithPlayer,(void**)&old_Gate_CollidingWithPlayer);
	MSHookFunction((void*)(0x1ECD8+1),(void *)Player_Update,(void**)&old_Player_Update);
	MSHookFunction((void*)(0x5CA68+1),(void *)missileSpeed,(void**)&old_missileSpeed);
	MSHookFunction((void*)(0xB2BF8+1),(void *)CreditsView_InsertItem,(void**)&old_CreditsView_InsertItem);

	Missile_Kill = (void (*)(void*))(0x1559F0+1);
	Missile_Destroy = (void (*)(void*))(0x1537C8+1);
	Player_IsDead = (bool (*)(void*))(0x228EC+1);
}
