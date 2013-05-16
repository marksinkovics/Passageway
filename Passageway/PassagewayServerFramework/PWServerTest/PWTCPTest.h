//
//  PWTCPTest.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 3/30/13.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "PWTCPServer.h"
#import "PWTCPPeer.h"

@interface PWTCPTest : SenTestCase <PWBaseServerDelegate, PWBasePeerDelegate>
{
	PWTCPServer* _server;
	PWTCPPeer* _client;
	
	BOOL _didStartServer;
	BOOL _didConnectClientAtServerSide;
	BOOL _didConnectClientAtClientSide;
	
	int _receivedDataCounterAtServerSide;
	int _receivedDataCounterAtClientSide;
	
	BOOL _didReceiveDataAtServerSide;
	BOOL _didReceiveDataAtClientSide;
}
@end
