//
//  MacroShared.h
//  PassagewayServerFramework
//
//  Created by Mark Sinkovics on 12/25/12.
//
//

#ifndef PassagewayServerFramework_MacroShared_h
#define PassagewayServerFramework_MacroShared_h

#ifndef PW_STRONG
	#if __has_feature(objc_arc)
		#define PW_STRONG strong
	#else
		#define PW_STRONG retain
	#endif
#endif

#ifndef PW_WEAK
	#if __has_feature(objc_arc_weak)
		#define PW_WEAK weak
	#elif __has_feature(objc_arc)
		#define PW_WEAK unsafe_unretained
	#else
		#define PW_WEAK assign
	#endif
#endif

#if __has_feature(objc_arc)
	#define PW_AUTORELEASE(exp) exp
	#define PW_RELEASE(exp) exp
	#define PW_RETAIN(exp) exp
#else
	#define PW_AUTORELEASE(exp) [exp autorelease]
	#define PW_RELEASE(exp) [exp release]
	#define PW_RETAIN(exp) [exp retain]
#endif

#ifndef PW_DEALLOC
	#if __has_feature(objc_arc)
		#define PW_DEALLOC() [super dealloc]
	#else
		#define PW_DEALLOC() [super dealloc]
	#endif
#endif


#endif
