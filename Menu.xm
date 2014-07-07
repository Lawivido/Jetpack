/*
Jetpack Cheats
By: Lawivido/Razzile
Credit Due: AlphaMatter
File: Tweak.xm

Features:
Auto Collect Coins [0x12CF0] WORKS
	MSHookFunction((void*)(0x12CF0+1),(void *)autoCoins,(void**)&old_autoCoins); [ON]
	MSHookFunction((void*)(0x12CF0+1),(void *)autoCoinsOff,(void**)&old_autoCoins); [OFF] [DOESN'T WORK]
Auto Collect Vehicle - WORKS
	MSHookFunction((void*)(0x897E8+1),(void *)autoVehicle,(void**)&old_autoVehicle);
Auto Collect Tokens - WORKS
	MSHookFunction((void*)(0x9C928+1),(void *)autoToken,(void**)&old_autoToken);
Invincibility - WORKS
	MSHookFunction((void*)(0x161C8+1),(void *)dumbLazer,(void**)&old_dumbLazer);
	MSHookFunction((void*)(0x154AF8+1),(void *)dumbMissile,(void**)&old_dumbMissile);
	MSHookFunction((void*)(0x1BB38+1),(void *)dumbGates,(void**)&old_dumbGates);
	MSHookFunction((void*)(0x15494C+1),(void *)dumbMissileBot,(void**)&old_dumbMissileBot); [UNTESTED]
Missile Speed - WORKS
	MSHookFunction((void*)(0x5CA68+1),(void *)missileSpeed,(void**)&old_missileSpeed);
Max Speed - NEED TO USE BOOST AT START OF LEVEL OR CRASH [NOT IN MENU, VELOCITY > THIS]
	MSHookFunction((void*)(0x23E78+1),(void *)boostHeadstart2,(void**)&old_boostHeadstart2);
	
To-Do
	1. Add Razzile's hacks
	2. Sliders
	3. Ability to turn hacks off
	4. Auto-Orientation
*/

#include "Settings.h"

@interface MortarAppDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>
@end

UIView *hookedView, *hacksView;
UITableView *hacksList;

NSMutableArray *cellNames;
UISlider *missileSpeedSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, hookedView.bounds.size.height/2, 275, 45.0)];

BOOL menuEnabled = false;

bool enabled[7] = {false,false,false,false,false,false,false};
const char* keyList[7] = {"kCurrency", "kCoins", "kVehicle", "kTokens", "kInvincibility", "kMissile"};
int hacksCount = 5;

UIButton *enableMenu;

NSMutableArray *missileSpeedValues;
NSString *missileSpeedSliderValue = @"Missile Speed Multiplier: 1.000000";

%hook MortarAppDelegate

-(void)applicationDidBecomeActive:(id)arg {
	hookedView = MSHookIvar<UIView*>(self,"_window");

	hacksView = [[UIView alloc] initWithFrame:CGRectMake(0,0, hookedView.bounds.size.width, hookedView.bounds.size.height)]; 

	[hacksView setBackgroundColor:[UIColor clearColor]];
	[hookedView addSubview:hacksView];
	[hacksView setHidden:YES];

	hacksList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, hookedView.bounds.size.width,hookedView.bounds.size.height) style:UITableViewStyleGrouped];
	[hacksList setBackgroundView:nil];
	[hacksList setDataSource:self];
	[hacksList setDelegate:self];
	[hacksList setAlpha:0.8];
	[hacksView addSubview:hacksList];
	[hacksList setHidden:YES];


	missileSpeedSlider.minimumValue = 1.0;
	missileSpeedSlider.maximumValue = 20.0;
	missileSpeedSlider.continuous = YES;
	missileSpeedSlider.value = jetpackSettings["kMissile"];
	[missileSpeedSlider addTarget:self action:@selector(missileSpeedSliderChanged:) forControlEvents:UIControlEventValueChanged];

 	enableMenu = [UIButton buttonWithType:UIButtonTypeCustom];
	[enableMenu setFrame: CGRectMake((hookedView.bounds.size.width/2)-40,0,80,20)];
	[enableMenu setTitle:@"Hacks" forState:UIControlStateNormal];
	[enableMenu addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];

	[hookedView addSubview: enableMenu];
	for (int i = 0; i < hacksCount; i++)
	{
		enabled[i] = jetpackSettings[keyList[i]];
	}
	return %orig;
}

%new
-(void)showMenu {
	if (!menuEnabled) {
		[hacksView setHidden:NO];
		[hacksList setHidden:NO];
	} else {
		[hacksView setHidden:YES];
		[hacksList setHidden:YES];
	}
}

%new
- (void)missileSpeedSliderChanged:(UISlider *)missileSpeedSlider {
	missileSpeedSliderValue = [NSString stringWithFormat:@"Missile Speed Multiplier: %f", missileSpeedSlider.value];
	NSIndexPath *missileSpeedCell = [NSIndexPath indexPathForRow:4 inSection:0];
	UITableViewCell *cell = [hacksList cellForRowAtIndexPath:missileSpeedCell];
	cell.textLabel.text = missileSpeedSliderValue;
	jetpackSettings["kMissile"] = missileSpeedSlider.value;
}

%new
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

%new
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(!cellNames)
		cellNames = [[NSMutableArray arrayWithObjects:@"Unlimited Coins",@"Auto Collect Coins",@"Auto Collect Vehicle",@"Auto Collect Tokens",@"Invincibility",@"Missile Speed Multiplier: 1.000000",@"",@"Return",nil] retain];
	return [cellNames count];
}

%new 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString* const SwitchCellID = @"SwitchCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SwitchCellID];

	if(cell == nil) { 
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		cell.textLabel.text = [cellNames objectAtIndex:indexPath.row];
		[cell setBackgroundColor:[UIColor whiteColor]];
		cell.textLabel.textColor = [UIColor blackColor];
}

	if (enabled[indexPath.row] && indexPath.row != 7 && indexPath.row != 6 && indexPath.row != 5) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	if (indexPath.row == 6) {
		[cell addSubview:missileSpeedSlider];
	}
	return cell;
}

%new
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 	if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone 
	&& [tableView cellForRowAtIndexPath:indexPath] != [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]]
	&& [tableView cellForRowAtIndexPath:indexPath] != [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]]
	&& [tableView cellForRowAtIndexPath:indexPath] != [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]]) {
		[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
	} else {
		[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
	}

	if (indexPath.row == 6) { 
		[hacksView setHidden:YES];
		[hacksList setHidden:YES];
		[enableMenu setHidden:NO];
	} else if (indexPath.row == 0) 
	{	//coins;
		bool coins = jetpackSettings["kCoins"];
		jetpackSettings["kCoins"] = !coins;	
		enabled[0] = !coins;
	} 
	else if (indexPath.row == 1) { //vehicles
		bool vehicles = jetpackSettings["kVehicle"];
		jetpackSettings["kVehicle"] = !vehicles;
		enabled[1] = !vehicles;	
	} else if (indexPath.row == 2) { //token
		bool tokens = jetpackSettings["kTokens"];
		jetpackSettings["kTokens"] = !tokens;
		enabled[2] = !tokens;		
	} else if (indexPath.row == 3) { //invincibility
		bool invincibility = jetpackSettings["kInvincibility"];
		jetpackSettings["kInvincibility"] = !invincibility;	
		enabled[3] = !invincibility;	
	} 
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

%end
