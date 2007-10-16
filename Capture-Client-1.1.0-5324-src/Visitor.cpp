/*
 *	PROJECT: Capture
 *	FILE: Visitor.cpp
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
#include "StdAfx.h"
#include "Visitor.h"

Visitor::Visitor(Common* g)
{
	global = g;
	hQueueNotEmpty = CreateEvent(NULL, FALSE, FALSE, NULL);
	wstring sEvent = L"visit";
	if(!global->serverEventDelegator->Register(this, sEvent))
	{
		printf("Visitor not listening for visit events from server\n");
	}

	wchar_t exListDriverPath[1024];
	GetCurrentDirectory(1024, exListDriverPath);
	wcscat_s(exListDriverPath, 1024, L"\\Clients.conf");
	wstring configListW = exListDriverPath;
	//Monitor::LoadExclusionList(configListW);
	LoadClientsList(configListW);
	Thread* visit = new Thread(this);

	visit->Start();
}

Visitor::Visitor()
{
}

Visitor::~Visitor(void)
{
	//delete toVisit;
	CloseHandle(hQueueNotEmpty);
}

bool
Visitor::LoadClientsList(wstring path)
{
		string line;
		int lineNumber = 0;
		
		ifstream configF (path.c_str());
		if (configF.is_open())
		{
			while (! configF.eof() )
			{
				getline (configF,line);
				lineNumber++;
				if((line.size() > 0) && (line.at(0) != '#'))
				{
					vector<std::wstring> splitLine;

					
					for(sf_it it=make_split_iterator(line, token_finder(is_any_of("\t")));
						it!=sf_it(); ++it)
					{
						splitLine.push_back(copy_range<std::wstring>(*it));				
					}

					if(splitLine.size() == 2)
					{
						// Naughty naughty .... !!!!!
						if(splitLine[0] == L"iexplore" || splitLine[0] == L"opera" || splitLine[0] == L"firefox" )
						{
							visitorClientsMap.insert(Client_Pair(splitLine[0], splitLine[1]));
						}
					}
				}
			}
		} else {
			printf("Visitor -- Could not open the client config file: %ls\n", path.c_str());
			return false;
		}
		configF.close();
		return true;
}

void
Visitor::Run()
{
	while(true)
	{
		WaitForSingleObject(hQueueNotEmpty, INFINITE);
		Url_Pair* url = toVisit.front();
		toVisit.pop();
		//toVisit.pop();

		// Pre event to unpause all of the monitors
		NotifyListeners(VISIT_PRESTART, url->second, url->first);

		NotifyListeners(VISIT_START, url->second, url->first);
		
	
		STARTUPINFO siStartupInfo;
		PROCESS_INFORMATION piProcessInfo;
		memset(&siStartupInfo, 0, sizeof(siStartupInfo));
		memset(&piProcessInfo, 0, sizeof(piProcessInfo));
		siStartupInfo.cb = sizeof(siStartupInfo);

		wchar_t blah[256];
		ZeroMemory(&blah, sizeof(blah));
		_tcscat_s(blah, 256, L"\"");
		_tcscat_s(blah, 256, url->first.c_str());
		_tcscat_s(blah, 256, L"\" ");
		_tcscat_s(blah, 256, url->second.c_str());
		LPTSTR szCmdline=_tcsdup(blah);
		bool created = CreateProcess(NULL,szCmdline, 0, 0, FALSE,
			CREATE_DEFAULT_ERROR_MODE, 0, 0, &siStartupInfo,
			&piProcessInfo);

		if(!created)
			NotifyListeners(VISIT_ERROR, url->second, url->first);

		Sleep(30000);

		if(!TerminateProcess(piProcessInfo.hProcess, 0))
		{
			printf("Process was terminated adbruptly -- possibly malicious\n");
			NotifyListeners(VISIT_ERROR, url->second, url->first);
		}

		// Wait for a little bit so that the processMonitor detects the process termination
		// before we tell the listeners ... a bit of a hack
		Sleep(1000);

		NotifyListeners(VISIT_FINISH, url->second, url->first);
		
		// Post event to pause all of the monitors
		NotifyListeners(VISIT_POSTFINISH, url->second, url->first);
	}
}

void
Visitor::OnReceiveEvent(vector<wstring> e)
{
	if((e.size() == 2))
	{
		// Support old legacy server code for the time being
		// TODO remove this
		stdext::hash_map<wstring, wstring>::iterator it;
		it = visitorClientsMap.find(L"iexplore");
		if(it != visitorClientsMap.end())
		{
			Client_Pair client = *it;
			Url_Pair* url = new Url_Pair(client.second, e[1]);
			toVisit.push(url);
			SetEvent(hQueueNotEmpty);
		}
	} else if(e.size() == 3) {
		stdext::hash_map<wstring, wstring>::iterator it;
		it = visitorClientsMap.find(e[1]);
		if(it != visitorClientsMap.end())
		{
			Client_Pair client = *it;
			Url_Pair* url = new Url_Pair(client.second, e[2]);
			toVisit.push(url);
			SetEvent(hQueueNotEmpty);
		} else {
			// Maybe default to iexplore if the client isn't found
		}
		
	}
}

void 
Visitor::AddVisitorListener(VisitorListener* vl)
{
	visitListeners.push_back(vl);
}

void
Visitor::RemoveVisitorListener(VisitorListener* vl)
{
	visitListeners.remove(vl);
}

void
Visitor::NotifyListeners(int eventType, wstring url, wstring visitor)
{
	std::list<VisitorListener*>::iterator lit;
	
	// Inform all registered listeners of event
	for (lit=visitListeners.begin(); lit!= visitListeners.end(); lit++)
	{
		(*lit)->OnVisitEvent(eventType, url, visitor);
	}
}
