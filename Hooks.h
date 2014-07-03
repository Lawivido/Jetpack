/*
Jetpack Cheats
By: Lawivido/Razzile
Credit Due: AlphaMatter 
File: Hooks.h
*/


float (*old_missileSpeed)(void *self, unsigned long speed);
bool (*old_autoCoins)(void *self, void *game);
bool (*old_autoVehicle)(void *self, void *game);
bool (*old_autoToken)(void *self, void *game);
bool (*old_dumbLazer)(void *self,void *game);
bool (*old_dumbMissile)(void *self, void *game);
void (*old_dumbMissileBot)(void *self);
bool (*old_dumbGates)(void *self, void *game);
bool (*old_boostHeadstart2)(void *self);