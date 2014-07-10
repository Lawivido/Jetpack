/*
Jetpack Cheats
By: Lawivido/Razzile
Credit Due: AlphaMatter
File: Menu.xm

To-Do
	1. Auto-Orientation
*/

#include "Settings.h"

#define degreesToRadian(angle) ((angle) / 180.0 * M_PI)

@interface MortarAppDelegate : NSObject <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, NSURLConnectionDelegate>
- (void)showMenu;
@end

NSString *currentVersion = @"1.0";

UIView *hookedView, *hacksView;
UITableView *hacksList;

NSMutableArray *cellNames;
UISlider *missileSpeedSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 0, 275, 45.0)];
NSString *missileSpeedSliderValue = @"Missile Speed Multiplier: 1.000000";

UISlider *runSpeedSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 0, 275, 45.0)];
NSString *runSpeedSliderValue = @"Run Speed Multiplier: 1.000000";

BOOL menuEnabled = false;

bool enabled[7] = {false,false,false,false,false,false,false};
const char* keyList[7] = {"kCurrency", "kCoins", "kVehicle", "kTokens", "kInvincibility", "kMissile", "kSpeed"};
int hacksCount = 6;

UIButton *enableMenu;

NSMutableArray *selectedItems;

NSURLConnection *connection;

%hook MortarAppDelegate

-(void)applicationDidBecomeActive:(id)arg {
	NSString *cfbVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]; 
	if([cfbVersion isEqualToString:@"1.7.0.1"] == NO)
	{
		return %orig;
	}
	hookedView = MSHookIvar<UIView*>(self,"_window");

	hacksView = [[UIView alloc] initWithFrame:CGRectMake(0,0, hookedView.bounds.size.height, hookedView.bounds.size.width)]; 

	[hacksView setBackgroundColor:[UIColor clearColor]];
	[hookedView addSubview:hacksView];
	[hacksView setHidden:YES];

	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	CGAffineTransform transform;
	switch (orientation) {
		case UIDeviceOrientationLandscapeLeft: {
			transform = CGAffineTransformMakeRotation(M_PI_2);
			[hacksView setTransform:transform];
			[enableMenu setTransform:transform];
			enableMenu.center = CGPointMake(20, 100);
			break;
		}
		case UIDeviceOrientationLandscapeRight: {
			transform = CGAffineTransformMakeRotation(270*M_PI/180);
			[hacksView setTransform:transform];
			[enableMenu setTransform:transform];
			enableMenu.center = CGPointMake(hookedView.bounds.size.width-20, 100);
			break;
		}
	}

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged) name:@"UIDeviceOrientationDidChangeNotification" object:nil];

	[hacksView setTransform:transform];
	hacksView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2);

	CGRect rect = CGRectMake(0,0,hacksView.bounds.size.width, hookedView.bounds.size.width);
	hacksList = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
	[hacksList setBackgroundView:nil];
	[hacksList setDataSource:self];
	[hacksList setDelegate:self];
	[hacksList setAlpha:0.8];
	[hacksView addSubview:hacksList];
	[hacksList setHidden:YES];
	hacksList.autoresizingMask =  UIViewAutoresizingFlexibleHeight;


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
	[enableMenu setFrame: CGRectMake(0,100,120,25)]; //hookedView.bounds.origin.x+(hookedView.bounds.size.height/2
	[enableMenu setTitle:@"Open Menu" forState:UIControlStateNormal];
	[enableMenu setTransform:transform];
	enableMenu.layer.borderColor = [UIColor whiteColor].CGColor;
	enableMenu.layer.borderWidth = 1.0f;
	[enableMenu addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];

	float missileSpeed = jetpackSettings["kMissile"];
	float runSpeed = jetpackSettings["kSpeed"];
	cellNames = [NSMutableArray arrayWithObjects:
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
								nil];

	selectedItems = [[NSMutableArray alloc] init];
	[hookedView addSubview: enableMenu];
	for (int i = 0; i < hacksCount; i++)
	{
		enabled[i] = jetpackSettings[keyList[i]];
		if (i < 5 && enabled[i]) {
			[selectedItems addObject:@(i)];
		}
	}
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://razzland.com/cheats/jetpack.php?vers=%@", currentVersion]]];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged) name:@"UIDeviceOrientationDidChangeNotification" object:nil];

	return %orig;
}

- (void)applicationWillResignActive:(id)application {
		[hacksView removeFromSuperview];
		[hacksList removeFromSuperview];
		[enableMenu removeFromSuperview];
		return %orig;
}

%new
- (void)orientationChanged {
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	CGAffineTransform transform;
	switch (orientation) {
		case UIDeviceOrientationLandscapeLeft: {
			transform = CGAffineTransformMakeRotation(M_PI_2);
			[hacksView setTransform:transform];
			[enableMenu setTransform:transform];
			enableMenu.center = CGPointMake(20, 100);
			break;
		}
		case UIDeviceOrientationLandscapeRight: {
			transform = CGAffineTransformMakeRotation(270*M_PI/180);
			[hacksView setTransform:transform];
			[enableMenu setTransform:transform];
			enableMenu.center = CGPointMake(hookedView.bounds.size.width-20, 100);
			break;
		}
	}

}

%new
-(void)showMenu {
	if (!menuEnabled) {
		[hacksView setHidden:NO];
		[hacksList setHidden:NO];
		[enableMenu removeFromSuperview];
		menuEnabled = true;
	} else {
		[hacksView setHidden:YES];
		[hacksList setHidden:YES];
		[hookedView addSubview:enableMenu];
		menuEnabled = false;
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
	return [cellNames count];
}

%new 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString* const SwitchCellID = [NSString stringWithFormat:@"%d-%d",indexPath.section,indexPath.row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SwitchCellID];

	if(cell == nil) { 
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SwitchCellID];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		cell.textLabel.text = [cellNames objectAtIndex:indexPath.row];
		[cell setBackgroundColor:[UIColor whiteColor]];
		cell.textLabel.textColor = [UIColor blackColor];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}

	if (indexPath.row < 6) {
		NSNumber *rowNum = @(indexPath.row);
		if ([selectedItems containsObject:rowNum]) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
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
		[self showMenu];
	}
	if (indexPath.row < 6)
	{
		bool value = jetpackSettings[keyList[indexPath.row]];
		jetpackSettings[keyList[indexPath.row]] = !value;
		enabled[indexPath.row] = !value;
		NSNumber *rowNum = @(indexPath.row);
		if ([selectedItems containsObject:rowNum])
		{
			[selectedItems removeObject:rowNum];
		}
		else
		{
			[selectedItems addObject:rowNum];
		}
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
			message:@"An Update is available for the mod menu, would you like to download?" 
			delegate:nil 
			cancelButtonTitle:@"No" 
			otherButtonTitles:@"Yes", nil];

		alert.delegate = self;
		[alert show];
	}
	else if([response isEqualToString:@"kill"])
	{
		system("rm /Library/MobileSubstrate/DynamicLibraries/jetpackemu.dylib");
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