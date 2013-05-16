//
//  PWConnectionTest.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 3/13/13.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "PWRemoteControlServerManager.h"
#import "PWRemoteControlClientManager.h"

@interface PWConnectionTest : SenTestCase <PWRemoteControlClientManagerDelegate, PWRemoteControlServerManagerDelegate>
{
	BOOL _hasConnected;
	BOOL _receivedAccessResponse;
	BOOL _receivedScreenSharingData;
	BOOL _receivedMouseData;
	BOOL _receivedKeyboardData;
	
	int _screenSharingDataCounter;
	int _loginCounter;
    
    PWRemoteControlServerManager* _serverManager;
    
    PWRemoteControlClientManager* _clientManager;
	
}
@end
