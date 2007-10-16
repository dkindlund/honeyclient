/*
 *	PROJECT: Capture
 *	FILE: RegistryMonitor.h
 *	AUTHORS: Ramon Steenson (rsteenson@gmail.com) & Christian Seifert (christian.seifert@gmail.com)
 *
 *	Developed by Victoria University of Wellington and the New Zealand Honeynet Alliance
 *
 *	This file is part of Capture.
 *
 *	Capture is free software; you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  Capture is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Capture; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */
#pragma once
#include "stdafx.h"
#include <windows.h>
#include <winioctl.h>
#include "Thread.h"
#include "Userenv.h"
#include "Monitor.h"
#include <PSAPI.h>

//From wdm.h - Registry data types
#define REG_NONE                    ( 0 )   // No value type
#define REG_SZ                      ( 1 )   // Unicode nul terminated string
#define REG_EXPAND_SZ               ( 2 )   // Unicode nul terminated string
                                            // (with environment variable references)
#define REG_BINARY                  ( 3 )   // Free form binary
#define REG_DWORD                   ( 4 )   // 32-bit number
#define REG_DWORD_LITTLE_ENDIAN     ( 4 )   // 32-bit number (same as REG_DWORD)
#define REG_DWORD_BIG_ENDIAN        ( 5 )   // 32-bit number
#define REG_LINK                    ( 6 )   // Symbolic Link (unicode)
#define REG_MULTI_SZ                ( 7 )   // Multiple Unicode strings
#define REG_RESOURCE_LIST           ( 8 )   // Resource list in the resource map
#define REG_FULL_RESOURCE_DESCRIPTOR ( 9 )  // Resource list in the hardware description
#define REG_RESOURCE_REQUIREMENTS_LIST ( 10 )
#define REG_QWORD                   ( 11 )  // 64-bit number
#define REG_QWORD_LITTLE_ENDIAN     ( 11 )  // 64-bit number (same as REG_QWORD)

typedef enum _REG_NOTIFY_CLASS {
    RegNtDeleteKey,
    RegNtPreDeleteKey = RegNtDeleteKey,
    RegNtSetValueKey,
    RegNtPreSetValueKey = RegNtSetValueKey,
    RegNtDeleteValueKey,
    RegNtPreDeleteValueKey = RegNtDeleteValueKey,
    RegNtSetInformationKey,
    RegNtPreSetInformationKey = RegNtSetInformationKey,
    RegNtRenameKey,
    RegNtPreRenameKey = RegNtRenameKey,
    RegNtEnumerateKey,
    RegNtPreEnumerateKey = RegNtEnumerateKey,
    RegNtEnumerateValueKey,
    RegNtPreEnumerateValueKey = RegNtEnumerateValueKey,
    RegNtQueryKey,
    RegNtPreQueryKey = RegNtQueryKey,
    RegNtQueryValueKey,
    RegNtPreQueryValueKey = RegNtQueryValueKey,
    RegNtQueryMultipleValueKey,
    RegNtPreQueryMultipleValueKey = RegNtQueryMultipleValueKey,
    RegNtPreCreateKey,
    RegNtPostCreateKey,
    RegNtPreOpenKey,
    RegNtPostOpenKey,
    RegNtKeyHandleClose,
    RegNtPreKeyHandleClose = RegNtKeyHandleClose,
    //
    // The following values apply only to Microsoft Windows Server 2003 and later.
    //    
    RegNtPostDeleteKey,
    RegNtPostSetValueKey,
    RegNtPostDeleteValueKey,
    RegNtPostSetInformationKey,
    RegNtPostRenameKey,
    RegNtPostEnumerateKey,
    RegNtPostEnumerateValueKey,
    RegNtPostQueryKey,
    RegNtPostQueryValueKey,
    RegNtPostQueryMultipleValueKey,
    RegNtPostKeyHandleClose,
    RegNtPreCreateKeyEx,
    RegNtPostCreateKeyEx,
    RegNtPreOpenKeyEx,
    RegNtPostOpenKeyEx,
    //
    // The following values apply only to Microsoft Windows Vista and later.
    //    
    RegNtPreFlushKey,
    RegNtPostFlushKey,
    RegNtPreLoadKey,
    RegNtPostLoadKey,
    RegNtPreUnLoadKey,
    RegNtPostUnLoadKey,
    RegNtPreQueryKeySecurity,
    RegNtPostQueryKeySecurity,
    RegNtPreSetKeySecurity,
    RegNtPostSetKeySecurity,
    RegNtCallbackContextCleanup,
    MaxRegNtNotifyClass 
} REG_NOTIFY_CLASS;
typedef struct _REGISTRY_EVENT
{
	int type;
	WCHAR name[512];
	UINT processID;
	ULONG regType;
	unsigned char regData[256];
	ULONG regDataSize;
} REGISTRY_EVENT, *PREGISTRY_EVENT;

struct UNICODE_STRING
{
	WORD Length;
	WORD MaximumLength;
	PWSTR Buffer;
};

typedef struct __PUBLIC_OBJECT_TYPE_INFORMATION {
    UNICODE_STRING TypeName;
    ULONG Reserved [22];    // reserved for internal use
} PUBLIC_OBJECT_TYPE_INFORMATION, *PPUBLIC_OBJECT_TYPE_INFORMATION;

typedef pair <wstring, wstring> Object_Pair;

#define NTSTATUS ULONG
#define STATUS_INFO_LENGTH_MISMATCH ((NTSTATUS)0xC0000004L)

class RegistryListener
{
public:
	virtual void OnRegistryEvent(wstring eventType, wstring processFullPath, wstring registryPath, wstring extraData) = 0;
};


#define IOCTL_EXAMPLE_SAMPLE_NEITHER_IO      CTL_CODE(FILE_DEVICE_UNKNOWN, 0x803, METHOD_NEITHER,FILE_READ_DATA | FILE_WRITE_DATA)


/*
	Class: RegistryMonitor
   
	NOT FINISHED YET
*/
class RegistryMonitor : public IRunnable, public Monitor
{
public:
	RegistryMonitor();
	~RegistryMonitor(void);
	
	/*
		Function: Start

		Creates a new thread <filemonThread> that monitors the <commPort> for incoming data
	*/
	void Start();
	/*
		Function: Stop

		Stops the thread stored in <filemonThread>
	*/
	void Stop();
	/*
		Function: Run

		Runnable thread which monitors the <commPort> for messages, retrieves them, parses them to events and checks if
		they are excluded before passing the event onto the listeners. If a message is passed it is considered malicious.
	*/
	void Run();
	/*
		Function: Pause

		Pauses the file monitor kernel driver so it does not listen for system wide file events
	*/
	void Pause();
	/*
		Function: UnPause

		Unpauses the file monitor kernel driver and starts listening for system wide file events
	*/
	void UnPause();

	/* Event methods */
	void AddRegistryListener(RegistryListener* rl);
	void RemoveRegistryListener(RegistryListener* rl);
	void NotifyListeners(wstring eventType, wstring processFullPath, wstring eventPath, wstring extraData);

private:
	Thread* regmonThread;
	HANDLE hDriver;
	bool installed;

	std::list<RegistryListener*> registryListeners;
	// Map from \REGISTRY\* to HKCU, HKLM etc
	std::list<Object_Pair> objectNameMap;
};
