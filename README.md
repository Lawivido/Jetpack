```
Jetpack Cheats
By: Lawivido/Razz
Credit Due: AlphaMatter
```

```
Features:
Auto Collect Coins [0x12CF0] WORKS
	MSHookFunction((void*)(0x12CF0+1),(void *)autoCoins,(void**)&old_autoCoins);
Auto Collect Vehicle - WORKS
	MSHookFunction((void*)(0x897E8+1),(void *)autoVehicle,(void**)&old_autoVehicle);
Auto Collect Tokens - WORKS
	MSHookFunction((void*)(0x9C928+1),(void *)autoToken,(void**)&old_autoToken);
Invincibility - WORKS
	MSHookFunction((void*)(0x161C8+1),(void *)dumbLazer,(void**)&old_dumbLazer);
	MSHookFunction((void*)(0x154AF8+1),(void *)dumbMissile,(void**)&old_dumbMissile);
	MSHookFunction((void*)(0x1BB38+1),(void *)dumbGates,(void**)&old_dumbGates);
Missile Speed - WORKS
	MSHookFunction((void*)(0x5CA68+1),(void *)missileSpeed,(void**)&old_missileSpeed);
Max Speed - NEED TO USE BOOST AT START OF LEVEL OR CRASH [NOT IN PATCHER, VELOCITY > THIS]
	MSHookFunction((void*)(0x23E78+1),(void *)boostHeadstart2,(void**)&old_boostHeadstart2);
```

```
To-Do
	1. Add Razzile's hacks
	2. Sliders
	3. Ability to turn hacks off
       4. Auto-Rotation
```

