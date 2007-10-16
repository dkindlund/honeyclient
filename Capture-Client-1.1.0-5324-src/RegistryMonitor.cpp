/*
 *	PROJECT: Capture
 *	FILE: RegistryMonitor.cpp
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
#include "RegistryMonitor.h"

RegistryMonitor::RegistryMonitor()
{
	wchar_t exListDriverPath[1024];
	wchar_t kernelDriverPath[1024];
	wchar_t szTemp[256];

	installed = false;

	GetCurrentDirectory(1024, exListDriverPath);
	wcscat_s(exListDriverPath, 1024, L"\\RegistryMonitor.exl");
	Monitor::LoadExclusionList(exListDriverPath);


	// Load registry monitor kernel driver
	GetCurrentDirectory(1024, kernelDriverPath);
	wcscat_s(kernelDriverPath, 1024, L"\\CaptureRegistryMonitor.sys");
	if(Monitor::InstallKernelDriver(kernelDriverPath, L"CaptureRegistryMonitor", L"Capture Registry Monitor"))
	{	
		hDriver = CreateFile(
					L"\\\\.\\Global\\CaptureRegistryMonitor",
					GENERIC_READ | GENERIC_WRITE, 
					FILE_SHARE_READ | FILE_SHARE_WRITE,
					0,                     // Default security
					OPEN_EXISTING,
					FILE_FLAG_OVERLAPPED,  // Perform asynchronous I/O
					0);                    // No template
		if(INVALID_HANDLE_VALUE == hDriver) {
			printf("RegistryMonitor: ERROR - CreateFile Failed: %i\n", GetLastError());
		} else {
			installed = true;
		}
	}

	// TODO seperate this into a new private function
	
	int count = 0;
	HKEY hTestKey;

	DWORD dwError = RegOpenCurrentUser(KEY_READ , &hTestKey);
	if (dwError == ERROR_SUCCESS )
	{
		NTSTATUS status;
		DWORD RequiredLength;
		PPUBLIC_OBJECT_TYPE_INFORMATION t;

		typedef DWORD (WINAPI *pNtQueryObject)(HANDLE,DWORD,VOID*,DWORD,VOID*);
		pNtQueryObject NtQueryObject = (pNtQueryObject)GetProcAddress(GetModuleHandle(L"ntdll.dll"), (LPCSTR)"NtQueryObject");
		
		status = NtQueryObject(hTestKey, 1, NULL,0,&RequiredLength);

		if(status == STATUS_INFO_LENGTH_MISMATCH)
		{
			t = (PPUBLIC_OBJECT_TYPE_INFORMATION)VirtualAlloc(NULL, RequiredLength, MEM_COMMIT, PAGE_READWRITE);
			if(status != NtQueryObject(hTestKey, 1,t,RequiredLength,&RequiredLength))
			{
				ZeroMemory(szTemp, 256);
				CopyMemory(&szTemp, t->TypeName.Buffer, RequiredLength);

				// Dont change the order of these ... _Classes should be inserted first
				// Small bug but who cares
				wstring temp2 = szTemp;
				temp2 += L"_CLASSES";
				wstring name2 = L"HKCR";
				objectNameMap.push_back(Object_Pair(temp2, name2));
				wstring temp1 = szTemp;
				wstring name1 = L"HKCU";
				objectNameMap.push_back(Object_Pair(temp1, name1));
				wstring temp3 = L"\\REGISTRY\\MACHINE";
				wstring name3 = L"HKLM";
				objectNameMap.push_back(Object_Pair(temp3, name3));
				wstring temp4 = L"\\REGISTRY\\USER";
				wstring name4 = L"HKU";
				objectNameMap.push_back(Object_Pair(temp4, name4));

			}
			VirtualFree(t, 0, MEM_RELEASE);
		}
	}

}

RegistryMonitor::~RegistryMonitor(void)
{
	CloseHandle(hDriver);
	Monitor::UnInstallKernelDriver();
}

void 
RegistryMonitor::Start()
{
	regmonThread = new Thread(this);
	regmonThread->Start();
}

void 
RegistryMonitor::Stop()
{
	regmonThread->Stop();
}

void 
RegistryMonitor::Pause()
{
	BOOL       bReturnCode = FALSE;
	DWORD      dwBytesReturned = 0;

	bReturnCode = DeviceIoControl(
		hDriver,
		IOCTL_CAPTURE_STOP,
		0, 
		0,
		0, 
		0,
		&dwBytesReturned,
		NULL
		);
}

void 
RegistryMonitor::UnPause()
{
	BOOL       bReturnCode = FALSE;
	DWORD      dwBytesReturned = 0;

	bReturnCode = DeviceIoControl(
		hDriver,
		IOCTL_CAPTURE_START,
		0, 
		0,
		0, 
		0,
		&dwBytesReturned,
		NULL
		);
}

void 
RegistryMonitor::Run()
{
	REGISTRY_EVENT rEvent[500];
	wchar_t szTemp[256];
	int count = 0;
	int wait = 150;
	wstring extraData; //For returning registry data which weren't previously returned in capture 1.1

	if(!installed)
	{
		printf("RegistryMonitor: ERROR - Kernel driver was not loaded properly\n");
		return;
	}

	while(true)
	{	
		ZeroMemory(&rEvent, sizeof(REGISTRY_EVENT)*500);
		DWORD dwReturn;
		
		DeviceIoControl(hDriver,
			IOCTL_EXAMPLE_SAMPLE_NEITHER_IO, 
			0, 
			0, 
			&rEvent, 
			sizeof(REGISTRY_EVENT)*500, 
			&dwReturn, 
			NULL);
		if(dwReturn == sizeof(REGISTRY_EVENT)*500)
		{
			wait = 10;
		} else {
			wait = 150;
		}
		//printf("Got: %i\n",dwReturn);
		for(unsigned int i = 0; i < (dwReturn/sizeof(REGISTRY_EVENT)); i++)
		{
			if(rEvent[i].processID > 0) {
			wstring eventName;
			wstring registryPath = rEvent[i].name;
			switch(rEvent[i].type)
			{
			case RegNtPostCreateKey:
				eventName = L"CreateKey";
				break;
			case RegNtPostOpenKey:
				eventName = L"OpenKey";
				//printf("Got: %i -- %ls\n", (DWORD)rEvent[i].processID, rEvent[i].name);
				break;
			case RegNtPreDeleteKey:
				eventName = L"DeleteKey";
				break;
			case RegNtDeleteValueKey:
				eventName = L"DeleteValueKey";
				break;
			case RegNtPreSetValueKey:
				eventName = L"SetValueKey";
				break;
			case RegNtEnumerateKey:
				eventName = L"EnumerateKey";
				break;
			case RegNtEnumerateValueKey:
				eventName = L"EnumerateValueKey";
				break;
			case RegNtQueryKey:
				eventName = L"QueryKey";
				break;
			case RegNtQueryValueKey:
				eventName = L"QueryValueKey";
				break;
			case RegNtKeyHandleClose:
				eventName = L"CloseKey";
				break;
			default:
				break;
			}

			std::list<Object_Pair>::iterator it;
			for(it = objectNameMap.begin(); it != objectNameMap.end(); it++)
			{
				size_t position = registryPath.rfind(it->first,0);
				if(position != wstring::npos)
				{
					registryPath.replace(position, it->first.length(), it->second, 0, it->second.length());
				}
			}

			ZeroMemory(&szTemp, sizeof(szTemp));
			wstring processModuleName;
			wstring processPath;
			extraData.clear();
			// Get process name and path
			if(Monitor::GetProcessCompletePathName((DWORD)rEvent[i].processID, &processPath, true))
			{
				processModuleName = processPath.substr(processPath.find_last_of(L"\\")+1);
			}

			//Fill in the rest of the info and put it into extraData
			switch(rEvent[i].regType){
				case REG_NONE:
					extraData.append(L"REG_NONE - ");
					break;
				case REG_SZ:
					extraData.append(L"REG_SZ - ");
					extraData.append((wchar_t *)rEvent[i].regData);
					break;
				case REG_EXPAND_SZ:
					extraData.append(L"REG_EXPAND_SZ - ");
					extraData.append((wchar_t *)rEvent[i].regData);
					break;
				case REG_BINARY:
					extraData.append(L"REG_BINARY - ");
					if(rEvent[i].regDataSize < 256){
						for(unsigned char n = 0; n < rEvent[i].regDataSize; n++){
							swprintf_s(szTemp, 256, L"%x", rEvent[i].regData[n]);
							//_swprintf(szTemp, L"%x", rEvent[i].regData[n]);
							extraData.append(szTemp);
						}
					}
					else{
						for(unsigned short n = 0; n <= 255; n++){
							swprintf_s(szTemp, 256, L"%x", rEvent[i].regData[n]);
							//_swprintf(szTemp, L"%x", (unsigned char *)(rEvent[i].regData)[n]);
							extraData.append(szTemp);
						}
					}
					break;
				case REG_DWORD:
					extraData.append(L"REG_DWORD - ");
					swprintf_s(szTemp, 256, L"%lx", ((DWORD *)rEvent[i].regData)[0]);
					extraData.append(szTemp);
					break;
				case REG_DWORD_BIG_ENDIAN:
					extraData.append(L"REG_DWORD_BIG_ENDIAN");
					break;
				case REG_LINK:
					extraData.append(L"REG_LINK");
					break;
				case REG_MULTI_SZ:
					extraData.append(L"REG_MULTI_SZ");
					break;
				case REG_RESOURCE_LIST:
					extraData.append(L"REG_RESOURCE_LIST");
					break;
				case REG_FULL_RESOURCE_DESCRIPTOR:
					extraData.append(L"REG_FULL_RESOURCE_DESCRIPTOR");
					break;
				case REG_RESOURCE_REQUIREMENTS_LIST:
					extraData.append(L"REG_RESOURCE_REQUIREMENTS_LIST");
					break;
				case REG_QWORD_LITTLE_ENDIAN:
					extraData.append(L"REG_QWORD(_LITTLE_ENDIAN)");
					break;
				default:
					extraData.append(L"UNKNOWN TYPE! ");
					swprintf_s(szTemp, 256, L" - %ld", rEvent[i].regType);
					extraData.append(szTemp);
					break;
			}


			if(!Monitor::EventIsAllowed(eventName,processPath,registryPath))
			{
				NotifyListeners(eventName, processPath, registryPath, extraData);
			}
			}
		}
		Sleep(wait);
	}
}

void
RegistryMonitor::NotifyListeners(wstring eventType, wstring processFullPath, wstring eventPath, wstring extraData)
{
	std::list<RegistryListener*>::iterator lit;
	//wcout << extraData << endl;
	// Inform all registered listeners of event
	for (lit=registryListeners.begin(); lit!= registryListeners.end(); lit++)
	{
		(*lit)->OnRegistryEvent(eventType, processFullPath, eventPath, extraData);
	}
}

void 
RegistryMonitor::AddRegistryListener(RegistryListener* pl)
{
	registryListeners.push_back(pl);
}

void
RegistryMonitor::RemoveRegistryListener(RegistryListener* pl)
{
	registryListeners.remove(pl);
}