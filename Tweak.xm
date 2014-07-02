/*
Jetpack Cheats
By: Lawivido/Razzile
Credit Due: AlphaMatter

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
Max Speed - NEED TO USE BOOST AT START OF LEVEL OR CRASH [NOT IN MENU, VELOCITY > THIS]
	MSHookFunction((void*)(0x23E78+1),(void *)boostHeadstart2,(void**)&old_boostHeadstart2);
	
To-Do
	1. Add Razzile's hacks
	2. Sliders
	3. Ability to turn hacks off
*/

#include <substrate.h>

UIView *hookedView, *hacksView;
UITableView *hacksList;

NSMutableArray *cellNames;

BOOL menuEnabled = false;

BOOL enabled[5] = {true,true,true,true,true};

float (*old_missileSpeed)(void *self, unsigned long speed);
bool (*old_autoCoins)(void *self, bool autocoin);
bool (*old_autoVehicle)(void *self, bool autovehicle);
bool (*old_autoToken)(void *self, bool autoToken);
bool (*old_dumbLazer)(void *self, bool dumb);
bool (*old_dumbMissile)(void *self, bool dumb);
bool (*old_dumbGates)(void *self, bool dumb);
bool (*old_boostHeadstart2)(void *self);

float missileSpeed(void *self, unsigned long speed) {
	return 1.0f;
}

bool autoCoins(void *self, bool autocoin) {
	return true;
}

bool autoVehicle(void *self, bool autovehicle) {
	return true;
}

bool autoToken(void *self, bool autotoken) {
	return true;
}

bool dumbLazer(void *self, bool dumb) {
	return false;
}

bool dumbMissile(void *self, bool dumb) {
	return false;
}

bool dumbGates(void *self, bool dumb) {
	return false;
}

bool boostHeadstart2(void *self) {
	return true;
}

@interface MortarAppDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>
@end

UIButton *enableMenu;

%hook MortarAppDelegate

-(void)applicationDidBecomeActive:(id)arg {
/* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Jetpack Joyride Hack" message:@"Hacked by Lawivido&Razzile for iOSCheaters.com!" delegate:nil cancelButtonTitle:@"Enjoy!" otherButtonTitles:nil];
[alert show];
[alert release]; */
	%orig;

	hookedView = MSHookIvar<UIView*>(self,"_window");

	hacksView = [[UIView alloc] initWithFrame:CGRectMake(0,0, hookedView.bounds.size.width, hookedView.bounds.size.height)]; 

	[hacksView setBackgroundColor:[UIColor clearColor]];
	[hookedView addSubview:hacksView];
	[hacksView setHidden:YES];

	hacksList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, hookedView.bounds.size.width,hookedView.bounds.size.height) style:UITableViewStyleGrouped];
	[hacksList setBackgroundView:nil];
	[hacksList setDataSource:self];
	[hacksList setDelegate:self];
	[hacksView addSubview:hacksList];
	[hacksList setHidden:YES];

 	enableMenu = [UIButton buttonWithType:UIButtonTypeCustom];
	[enableMenu setFrame: CGRectMake((hookedView.bounds.size.width/2)-40,0,80,20)];
	[enableMenu setTitle:@"Hacks" forState:UIControlStateNormal];
	[enableMenu addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];

	[hookedView addSubview: enableMenu];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

%new
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	cellNames = [[NSMutableArray arrayWithObjects:@"Auto Collect Coins",@"Auto Collect Vehicle",@"Auto Collect Tokens",@"Invincibility",@"Missile Speed",@"Return",nil] retain];
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

	if (!enabled[indexPath.row] && indexPath.row != 6) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	return cell;
}

%new
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone 
	&& [tableView cellForRowAtIndexPath:indexPath] != [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]]) {
		[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
	} else {
		[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
	}

	if (indexPath.row == 6) { 
		[hacksView setHidden:YES];
		[hacksList setHidden:YES];
		[enableMenu setHidden:NO];
	} else if (indexPath.row == 0) { //coins
		enabled[0] = false;
		MSHookFunction((void*)(0x12CF0+1),(void *)autoCoins,(void**)&old_autoCoins);
		UIAlertView *testAlert = [[UIAlertView alloc] initWithTitle:@"Test1" message:@"Test1" delegate:nil cancelButtonTitle:@"Test1" otherButtonTitles:nil];
		[testAlert show];
		[testAlert release];
	} else if (indexPath.row == 1) { //vehicles
		enabled[1] = false;
		MSHookFunction((void*)(0x897E8+1),(void *)autoVehicle,(void**)&old_autoVehicle);
		UIAlertView *testAlert2 = [[UIAlertView alloc] initWithTitle:@"Test2" message:@"Test2" delegate:nil cancelButtonTitle:@"Test2" otherButtonTitles:nil];
		[testAlert2 show];
		[testAlert2 release];		
	} else if (indexPath.row == 2) { //token
		enabled[2] = false;
		MSHookFunction((void*)(0x9C928+1),(void *)autoToken,(void**)&old_autoToken);
		UIAlertView *testAlert3 = [[UIAlertView alloc] initWithTitle:@"Test3" message:@"Test3" delegate:nil cancelButtonTitle:@"Test3" otherButtonTitles:nil];
		[testAlert3 show];
		[testAlert3 release];	
	} else if (indexPath.row == 3) { //invincibility
		enabled[3] = false;
		MSHookFunction((void*)(0x161C8+1),(void *)dumbLazer,(void**)&old_dumbLazer);
		MSHookFunction((void*)(0x154AF8+1),(void *)dumbMissile,(void**)&old_dumbMissile);
		MSHookFunction((void*)(0x1BB38+1),(void *)dumbGates,(void**)&old_dumbGates);
		UIAlertView *testAlert4 = [[UIAlertView alloc] initWithTitle:@"Test4" message:@"Test4" delegate:nil cancelButtonTitle:@"Test4" otherButtonTitles:nil];
		[testAlert4 show];
		[testAlert4 release];	
	} else if (indexPath.row == 4) { //missile speed - need slider
		enabled[4] = false;
		MSHookFunction((void*)(0x5CA68+1),(void *)missileSpeed,(void**)&old_missileSpeed);
		UIAlertView *testAlert5 = [[UIAlertView alloc] initWithTitle:@"Test5" message:@"Test5" delegate:nil cancelButtonTitle:@"Test5" otherButtonTitles:nil];
		[testAlert5 show];
		[testAlert5 release];	
	}

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

%end