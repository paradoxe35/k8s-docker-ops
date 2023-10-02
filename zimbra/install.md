## **Prerequisites for Installing Zimbra Ubuntu**

- Ubuntu 18.04 Sever
- 4 CPU
- RAM 8GB Minimal
- 50 GB Hardisk
- Server DNS

See also

- [Install Ubuntu Server 18.04](https://dixmata.com/2021/10/16/install-ubuntu-server/)

Before starting the tutorial Install Zimbra on Ubuntu 18.04 in the installation , we have to create a domain for zimbra. For dns we use DNSmasq.

**DNSmasq is a software that functions to store the IP of the sites that are accessed, in other words, a cache of the IPs of the sites that we access.**

The advantages of using dnsmasq are

- A simple configuration file is centralized in _<kbd>/etc/dnsmasq.conf</kbd>_
- DNS Masquerade set-up is simpler to use as Local DNS compared to using BIND which has complex features
- DNS Masquerade will read the _<kbd>/etc/hosts</kbd>_ configuration as an A Record of each name server to be looked up
- Simple

([https://www.ilmuzimbra.com/](https://www.ilmuzimbra.com/)).

Catatan

1. IP Address = 172.20.2.90
2. Zimbra = Zimbra 8.8.15 GA Release
3. Domain = dixmata.com

## Step 1: Update And Upgrade Linux (Install Zimbra Ubuntu 18.04)

First, for how to install Zimbra on Ubuntu 18.04, we have to update and upgrade packages on linux, so that everything needed to install Zimbra goes well.

apt update && apt upgrade

## Step 2: Edit Hostname and Linux Hosts File (Install Zimbra Ubuntu 18.04)

Edit Hostname and the Hosts file on Linux is located edit in _<kbd>/etc/hostname</kbd>_. Hostname is the name that will be used for our server. In addition, Hostname is also used for server identity.

```
nano /etc/hostname
```

Then fill in the domain you are using, here we use the example of **_mail.dixmata.com_**

![](https://dixmata.com/wp-content/uploads/2021/11/Hostname-2.png)

![](https://dixmata.com/wp-content/uploads/2021/11/Hostname-2.png)

Replace with the Domain name that will be used, then edit the hosts file with the following command:

nano /etc/hosts

![](https://dixmata.com/wp-content/uploads/2021/11/Hosts.png)

![](https://dixmata.com/wp-content/uploads/2021/11/Hosts.png)

And Reboot

```
reboot
```

## Step 3: Install dnsmasq

Next Install Zimbra Ubuntu, we will install dnsmasq as a DNS server. But before that we must first turn off systemd-resolve which is running on port 53, because DNS is also running on port 53 which causes the port to conflict.

systemctl disable systemd-resolved

systemctl stop systemd-resolved

## Step 4: Configure Resolv File (Install Zimbra Ubuntu)

The basic configuration of the ubuntu resolv file is already linked with the ubuntu system, so to use dnsmasq we have to remove the link first.

To see if a file is still symlinked, use the following command:

ls -lh /etc/resolv.conf

Delete the resolv.conf file, follow the following command.

rm -f /etc/resolv.conf

Now create a new resolv.conf file and fill in the Google DNS server, follow the following command

nano /etc/resolv.conf

![](https://dixmata.com/wp-content/uploads/2021/11/Resolv.png)

![](https://dixmata.com/wp-content/uploads/2021/11/Resolv.png)

Install dnsmasq , follow the following command

apt install dnsmasq -y

## Step 5: Configure Dnsmasq(Install Zimbra Ubuntu)

After installing Dnsmasq, then configuring Dnsmasq, open the dnsmasq.conf file located in **/etc/dnsmasq.conf.**

Backup the default dnsmasq configuration file, namely dnsmasq.conf, if there is an error in the configuration, we can restore it to the beginning. Follow these commands:

cp /etc/dnsmasq.conf /etc/dnsmasq.conf.bak

Edit file dnsmasq.conf

nano /etc/dnsmasq.conf

Follow the following configuration, changing ip-address and dixmata.com according to what you are using.

```
server= 172.20.2.90
domain=dixmata.com
mx-host= dixmata.com, mail.dixmata.com, 5
mx-host= mail.dixmata.com, mail.dixmata.com, 5
listen-address=127.0.0.1
```

Restart service dnsmasq

systemctl restart dnsmasq

Test A Record mail.

Dig for an A record of Zimbra Server.

dig A mail.dixmata.com

![](https://dixmata.com/wp-content/uploads/2021/11/dig-A-1.png)

![](https://dixmata.com/wp-content/uploads/2021/11/dig-A-1.png)

Continue with Test MX Record Domain

dig MX dixmata.com

![](https://dixmata.com/wp-content/uploads/2021/11/dig-Mx.png)

![](https://dixmata.com/wp-content/uploads/2021/11/dig-Mx.png)

[![Affiliate Banner Unlimited Hosting Indonesia](https://niagaspace.sgp1.cdn.digitaloceanspaces.com/assets/images/affiliasi/banner/728-90-affiliate-starting-bisnis-online.png)

![Affiliate Banner Unlimited Hosting Indonesia](https://niagaspace.sgp1.cdn.digitaloceanspaces.com/assets/images/affiliasi/banner/728-90-affiliate-starting-bisnis-online.png)

](https://panel.niagahoster.co.id/ref/697327)

## Step 6: Download Zimbra Collaboration Open Source Edition

The next step in Installing Zimbra Ubuntu is downloading Zimbra Collaboration, because in this tutorial using Ubuntu 18.04, the Zimbra that will be downloaded is Zimbra Ubuntu 18.04, to download Zimbra you can link [Download Zimbra](https://www.zimbra.com/downloads/ "https://www.zimbra.com/downloads/")

![](https://dixmata.com/wp-content/uploads/2021/11/Install-Zimbra-Ubuntu-Donwload-Package-Dixmata_.jpg)

![](https://dixmata.com/wp-content/uploads/2021/11/Install-Zimbra-Ubuntu-Donwload-Package-Dixmata_.jpg)

In the picture above, there are several types of OS that can be used to install Zimbra Ubuntu, specifically for this discussion, we use Ubuntu 18.04 LTS, so choose the Ubuntu 18.04 LSTS platform

or you can also use the wget command at the download url of the zimbra packet, as below

wget https://files.zimbra.com/downloads/8.8.15\_GA/zcs-8.8.15\_GA\_3869.UBUNTU18\_64.20190918004220.tgz

Wait a few moments until the download is complete, and if you have extracted the zimbra file that has been downloaded in the .tgz format

Use the following command to extract the zimbra file that has been downloaded tdi

tar -xvf zcs-8.8.15_GA_3869.UBUNTU18_64.20190918004220.tgz

If it has been successfully extracted, then move to the zimbra folder:

cd zcs-8.8.15_GA_3869.UBUNTU18_64.20190918004220

## Step 6: Install Zimbra Collaboration on

After the download is successful and the file has been extracted, the next step is to install Zimbra Collaboration.

Inside the extracted zimbra folder, there is a file with the extension .sh (.install.sh). Run the Script file path.

Run the installer script.

sudo ./install.sh

![](https://dixmata.com/wp-content/uploads/2021/11/Install-SH.png)

![](https://dixmata.com/wp-content/uploads/2021/11/Install-SH.png)

When Zimbra gives a notification of the Software License agreement, **select “Y**” and do the same on Zimbra’s package repository Installation.

If there is an **error** like the one below:

![](https://dixmata.com/wp-content/uploads/2021/11/Error.png)

![](https://dixmata.com/wp-content/uploads/2021/11/Error.png)

Follow the following command

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 9BE6ED79

And run **<kbd>./Install.sh</kbd>** again

sudo ./install.sh

After that zimbra will continue the installation.

In the packages installation, select **“Y”** for each package except for the “**zimbra-imapd**” package. We do not use these packages because the version is still in Beta.

![](https://dixmata.com/wp-content/uploads/2021/11/Install-Part3-1-1.png)

![](https://dixmata.com/wp-content/uploads/2021/11/Install-Part3-1-1.png)

When finished, the system notification will be changed, select YES”

**The system will be modified. Continue? \[N\] y**

and Installation will start. The installation process will take a few minutes, wait for it to finish, do not restart or shut down your server.

After the installation is complete, we will be asked to configure some menus

#### 1\. Menu DNS Cache

![](https://dixmata.com/wp-content/uploads/2021/11/Dns-Cache-UNSET.png)

![](https://dixmata.com/wp-content/uploads/2021/11/Dns-Cache-UNSET.png)

**Select 5** which is “zimbra-dnscache” , then **select 2** “Master DNS IP address(es)”

Fill it with google dns which is 8.8.8.8

![install zimbra](https://dixmata.com/wp-content/uploads/2021/11/MasterDNS-8.8.8..png)

![install zimbra](https://dixmata.com/wp-content/uploads/2021/11/MasterDNS-8.8.8..png)

Then type **“r”** to go back

#### 2\. Menu Password Admin

Press 7 to add Admin Password

**Address unconfigured (\*\*) items (? – help) 7**

![install zimbra](https://dixmata.com/wp-content/uploads/2021/11/Password.png)

![install zimbra](https://dixmata.com/wp-content/uploads/2021/11/Password.png)

Then now to create an Admin Password, **press “4”**. We will be asked to set the admin password. Type the Password which must contain **6 Characters**.

**Select, or ‘r’ for previous menu \[r\] 4**

![install zimbra](https://dixmata.com/wp-content/uploads/2021/11/Store-Configurasi-Password-Install-Zimbra-Dixmata.jpg)

![install zimbra](https://dixmata.com/wp-content/uploads/2021/11/Store-Configurasi-Password-Install-Zimbra-Dixmata.jpg)

Then enter Password

![](https://dixmata.com/wp-content/uploads/2021/11/image.png)

![](https://dixmata.com/wp-content/uploads/2021/11/image.png)

After typing the password, enter Enter and **press the ‘r’** key on the keyboard to return to the Main Menu

**Select, or ‘r’ for previous menu \[r\]**

Now to save the completed configuration but press the ‘a’ key on the keyboard.

**Select from menu, or press ‘a’ to apply config (? – help) a**

And there will be a notification to save the configuration that has been made, **Type ‘Yes’**

![install zimbra](https://dixmata.com/wp-content/uploads/2021/11/Install-Zimbra-Ubuntu-Set-Password-Dixmata-3.jpg)

![install zimbra](https://dixmata.com/wp-content/uploads/2021/11/Install-Zimbra-Ubuntu-Set-Password-Dixmata-3.jpg)

**Save configuration data to a file? \[Yes\] Yes**

**The system will be modified – continue? \[No\] Yes**

Then Enter and wait for Zimbra to complete the configuration that was made earlier.

Followed by the message Notify Zimbra of your installation? \[Yes\], then select **No**

```
Notify Zimbra of your installation? [Yes] Yes
Notifying Zimbra of installation via http://www.zimbra.com/cgi-bin/notify.cgi?VER=8.8.15_GA_3869_UBUNTU18_64&MAIL=admin@mail.dixmata.com

```

## Step 7 : Access Zimbra Dashaboard Admin

Now we are done installing Zimbra Ubuntu, and we can access the zimbra dashboard, if on linux there is a firewall, so that the firewall is disabled first, until the zimbra configuration is completely completed

Open a web browser and type

[**https://ip-address:7071**](https://ip-address:7071/)

atau

[**https:// FQDN:7071**](https://%20fqdn%20:7071/)

The Zimbra Admin default page will appear, Enter the Username and Password, Enter the username and password for the one that was set in the previous step.

![install zimbra](https://dixmata.com/wp-content/uploads/2021/11/Install-Zimbra-Ubuntu-Set-Password-Dixmata-4-1024x676.jpg)

![install zimbra](https://dixmata.com/wp-content/uploads/2021/11/Install-Zimbra-Ubuntu-Set-Password-Dixmata-4-1024x676.jpg)

We have practiced how to install Zimbra on Ubuntu 18.04 and it has worked, so for those of you who want to try or have problems, you can contact us again.

Thank you for following this Tutorial How to Install Zimbra on Ubuntu 18.04, hopefully it will be useful and can be a lesson for all of us and can share knowledge with others.
