/*
Jetpack Cheats
By: Lawivido/Razzile
Credit Due: AlphaMatter
File: Menu.xm

To-Do
	1. Auto-Orientation
*/

#include "Settings.h"

@interface MortarAppDelegate : NSObject <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, NSURLConnectionDelegate>
@end

NSString *currentVersion = @"1.0";

UIView *hookedView, *hacksView;
UITableView *hacksList;

NSMutableArray *cellNames;
UISlider *missileSpeedSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, hookedView.bounds.size.height/2, 275, 45.0)];
NSString *missileSpeedSliderValue = @"Missile Speed Multiplier: 1.000000";

UISlider *runSpeedSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, hookedView.bounds.size.height/2, 275, 45.0)];
NSString *runSpeedSliderValue = @"Run Speed Multiplier: 1.000000";

BOOL menuEnabled = false;

bool enabled[7] = {false,false,false,false,false,false,false};
const char* keyList[7] = {"kCurrency", "kCoins", "kVehicle", "kTokens", "kInvincibility", "kMissile", "kSpeed"};
int hacksCount = 6;

UIButton *enableMenu;


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
	missileSpeedSlider.maximumValue = 50.0;
	missileSpeedSlider.continuous = YES;
	missileSpeedSlider.value = jetpackSettings["kMissile"];
	[missileSpeedSlider addTarget:self action:@selector(missileSpeedSliderChanged:) forControlEvents:UIControlEventValueChanged];

	runSpeedSlider.minimumValue = 10.0;
	runSpeedSlider.maximumValue = 2000.0;
	runSpeedSlider.continuous = YES;
	runSpeedSlider.value = jetpackSettings["kSpeed"];
	[runSpeedSlider addTarget:self action:@selector(runSpeedSliderChanged:) forControlEvents:UIControlEventValueChanged];

 	enableMenu = [UIButton buttonWithType:UIButtonTypeCustom];
	[enableMenu setFrame: CGRectMake((hookedView.bounds.size.width/2)-40,0,80,20)];
	[enableMenu setTitle:@"Hacks" forState:UIControlStateNormal];
	[enableMenu addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];

	[hookedView addSubview: enableMenu];
	for (int i = 0; i < hacksCount; i++)
	{
		enabled[i] = jetpackSettings[keyList[i]];
	}
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://razzland.com/cheats/jetpack.php?vers=%@", currentVersion]]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
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
	NSIndexPath *missileSpeedCell = [NSIndexPath indexPathForRow:5 inSection:0];
	UITableViewCell *cell = [hacksList cellForRowAtIndexPath:missileSpeedCell];
	cell.textLabel.text = missileSpeedSliderValue;
	jetpackSettings["kMissile"] = missileSpeedSlider.value;
}

%new
- (void)runSpeedSliderChanged:(UISlider *)runSpeedSlider {
	runSpeedSliderValue = [NSString stringWithFormat:@"Run Speed Multiplier: %f", runSpeedSlider.value];
	NSIndexPath *runSpeedCell = [NSIndexPath indexPathForRow:7 inSection:0];
	UITableViewCell *cell = [hacksList cellForRowAtIndexPath:runSpeedCell];
	cell.textLabel.text = runSpeedSliderValue;
	jetpackSettings["kSpeed"] = runSpeedSlider.value;
}

%new
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

%new
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(!cellNames)
	{
		float missileSpeed = jetpackSettings["kMissile"];
		float runSpeed = jetpackSettings["kSpeed"];
		cellNames = [[NSMutableArray arrayWithObjects:
								@"Unlimited Coins",
								@"Auto Collect Coins",
								@"Auto Collect Vehicle",
								@"Auto Collect Tokens",
								@"Invincibility",
								[NSString stringWithFormat:@"Missile Speed Multiplier: %f", missileSpeed],
								@"",
								[NSString stringWithFormat:@"Run Speed Multiplier: %f", runSpeed],
								@"",
								@"Return",
								nil] retain];
	}
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

	if (enabled[indexPath.row] &&  indexPath.row != 9 && indexPath.row != 8 && indexPath.row != 7 && indexPath.row != 6 && indexPath.row != 5) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	if (indexPath.row == 6) {
		[cell addSubview:missileSpeedSlider];
	}
	if (indexPath.row == 8) {
		[cell addSubview:runSpeedSlider];
	}
	return cell;
}

%new
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 	if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone 
	&& [tableView cellForRowAtIndexPath:indexPath] != [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]]
	&& [tableView cellForRowAtIndexPath:indexPath] != [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]]
	&& [tableView cellForRowAtIndexPath:indexPath] != [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]]
	&& [tableView cellForRowAtIndexPath:indexPath] != [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]]
	&& [tableView cellForRowAtIndexPath:indexPath] != [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]]) {
		[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
	} else {
		[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
	}

	if (indexPath.row == 9) { 
		[hacksView setHidden:YES];
		[hacksList setHidden:YES];
		[enableMenu setHidden:NO];
	} else if (indexPath.row == 0) 
	{
		bool currency = jetpackSettings["kCurrency"];
		jetpackSettings["kCurrency"] = !currency;	
		enabled[0] = !currency;
	} 
	else if (indexPath.row == 1) 
	{
		bool coins = jetpackSettings["kCoins"];
		jetpackSettings["kCoins"] = !coins;	
		enabled[0] = !coins;
	} 
	else if (indexPath.row == 2) {
		bool vehicles = jetpackSettings["kVehicle"];
		jetpackSettings["kVehicle"] = !vehicles;
		enabled[1] = !vehicles;	
	} 
	else if (indexPath.row == 3) { 
		bool tokens = jetpackSettings["kTokens"];
		jetpackSettings["kTokens"] = !tokens;
		enabled[2] = !tokens;		
	} 
	else if (indexPath.row == 4) { 
		bool invincibility = jetpackSettings["kInvincibility"];
		jetpackSettings["kInvincibility"] = !invincibility;	
		enabled[3] = !invincibility;	
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

%new
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	if([response isEqualToString:@"update"])
	{
		UIAlertView *alert = [[UIAlertView alloc] 
			initWithTitle:@"Update" 
			message:@"An Update is available for the mod menu, would you like to download? " 
			delegate:nil 
			cancelButtonTitle:@"No" 
			otherButtonTitles:@"Yes", nil];

		alert.delegate = self;
		[alert show];
		[alert release];
	}
	else if([response isEqualToString:@"kill"])
	{
		exit(0);
	}
}

%new
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Yes"])
    {
    	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://ioscheaters.com/topic/5286-jetpack-joyride-mod-menu-v1701/"]];
    }
}


%end
