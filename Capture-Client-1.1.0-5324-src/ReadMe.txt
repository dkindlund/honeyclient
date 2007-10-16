1. Capture Client README
------------------------
Capture allows to search and identify malicious servers on a network. Capture is split into two functional areas: a Capture Server and Capture Client. The Capture clients accept the commands of the server to start and stop themselves and to visit a web server. As a Capture client interacts with a web server, it monitors its state for changes to processes that are running, the registry, and the file system. Since some events occur during normal operation (e.g. windows update runs frequently), exclusion lists allow to ignore certain type of events. If changes are detected that are not part of the exclusion list, the client makes a malicious classification of the web server and sends this information to the Capture server. Since the state of the Capture client has been changed, the Capture client resets its state to a clean state before it retrieves new instructions from the Capture server. In case no state changes are detected, the Capture client retrieves new instructions from the Capture server without resetting its state.

Capture is written and distributed under the GNU General Public License.

2. Prerequisites
----------------
The Capture client component runs inside of a virtual machine (guest os). This guide will go through the stages of installing VMware server and configuring the virtual machine through to intalling the client on the guest os. 

2.1 Installing VMware Server
----------------------------
Install VMware server using any means available: 

* On Linux, use either you package management software available on your distribution or download it from here http://www.vmware.com/download/server/ 
* On Windows, download the setup software from http://www.vmware.com/download/server/ 

Linux requires a little bit of fiddling. The ports must be opened, and the VMware server must be allowed to authenticate with the users on the host machine. On Linux, VMware server uses xinetd to authenticate the incoming connections with users on the host machine. This requires that xinetd be set up to accept remote authentication. Do the following: 
1. Open up the file /etc/xinetd.conf (Maybe be different depending on the distribution) 
2. Look for the line labelled only_from and add the IP addresses you are expecting remote authentication from 
@@only_from = 192.168.0.20;192.168.0.2 
On Windows, VMware server should be able to accept incoming connections already. However you may need to open up the port which it listens on (default is 902) in the Windows firewall. 

2.2 Creating a Virtual Machine
------------------------------
Capture uses Windows XP SP2, thus the virtual machine that is to be created is to be Windows XP SP2. 

* Create a virtual machine 
* Install Windows XP onto the virtual machine 
* Install the VMware tools 

2.3 Configure the Virtual Machine inside VMware Server
------------------------------------------------------
The created VM needs to be configured in a way such that it resumes to the last (clean) snapshot taken when we issue a shutdown command to the VM. First create an initial snapshot (this will be updated once the installation and configuration of the Capture component has been completed). Second, configure the VM to revert to the last snapshot upon a shutdown event: 

* Goto the virtual machine settings dialog. 
* Goto the options tab 
* Goto the Snapshot option panel 
* Change the option labelled "When Powering Off" 
	* Change to Revert to snapshot 
* OK the changes 

Further, we need to configure the virtual machine to run the Capture client component once the virtual machine resumes. This allows the Capture client to automatically register with the Capture server once its virtual machine has been resumed: 

* Open VMware tools config. Control Panel -> VMware Tools 
* Goto the scripts tab 
* Select the Resume guest OS script and click edit 
* Add these lines after VMip --renew 
	* cd <the directory where the capture client will be located> 
	* Capture.exe <Capture server ip address> 

3. Installing the Capture Client Component on the Virtual Machine
-----------------------------------------------------------------
Download the Capture client component and extract it into the directory specified in the previous section. Open Windows Explorer and navigate to this directory. Right click on the inf files and select install.

4. Configure Capture Client Component
-------------------------------------
The capture client currently is able to detect changes to the processes running on the system, modifications to the registry and modifications to the file system. Since the system will generate events during normal operation that are not malicious, exclusion lists are provided to exclude these events from causing a malicious classification of the URI. An empty exclusion list would mean that no events are allowed at all. There are three exclusion lists that allow to exclude these three event types respectively: ProcessMonitor.exl, FileMonitor.exl, and RegistryMonitor.exl. Default exclusion list are provided with Capture that exclude events that normally occur when browsing benign web pages.

The ProcessMonitor.exl allows to specify processes that should not be triggering a malicious classification. One process should be listed per line. By default, the client process IEXPLORE is contained in the ProcessMonitor.exl. Without this line item, any URI would be classified as malicious as the IEXPLORE process is created as part of retrieving a URI. 

The FileMonitor.exl allows to specify files that should not be triggering a malicious classification. There is the option to specify whether read or write events on specific files should be excluded as well as specifying the process that causes these events. So, for example, one can exclude write and read file events in the temp Internet Cache folder that are caused by Internet Explorer from triggering a malicious classification. However, access by another process on these files would. 

The RegistryMonitor.exl allows to specify registry events that should not be triggering a malicious classification. There is the option to specify whether read or write events on specific registry keys or values should be excluded as well as specifying the process that causes these events. 

In addition to the exclusion list, one can configure the client identifiers of the client honeypot. The client identifiers are pointers to client applications that can be used to interact with a server, such as Internet Explorer and Firefox. Simply add the client identfier and fully qualifying path name to the client.conf file and specify the client identifier with the url that should be interacted with in the uri list that is piped to the server, e.g. Firefox::http://www.google.com. Currently only browsers Internet Explorer and Firefox are supported.

Once the software is installed and configured it is time to create a new snapshot which we call a "safe state". This is the state that the machine is in perfect working order, i.e. no malicious programs are installed and the machine is considered to be clean. This state is reverted back to when a malicious event occurs inside of the virtual machine. When the virtual machine is running Windows XP and is fully booted, click on the Snapshot button in the VMware server to create a snapshot (May take some time so just leave it for a few minutes) 

6. Executing Unit Tests
-----------------------
Capture provides unit tests which provide an automated way to make sure Capture client and Capture server are setup correctly. It is recommended you run these tests after Capture client and Capture server have been installed and configured and before executing either of the server or client components. 

To compile the unit tests after you comment out the line //#define UNITTEST 1 in the stdafx.h file. 
To run the client unit test, simply run the specially compiled version of Capture.exe.

The tests cover the Process monitor, Registry monitor, File monitor, and the client's ability to correctly determine the state of the machine as malicious or benign. 


