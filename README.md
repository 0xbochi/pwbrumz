![](./.github/banner.png)

<p align="center">
  A PowerShell script to manage all your windows servers.
</p>

## What is pwbrumz?

pwbrumz is a tool written in PowerShell that allows you to launch ready-made modules (or build your own) on your Windows servers.
It is useful for updating a fleet of Windows servers and allows the use of already functional modules to save your time.

You just need to clone the repository and have powershell on the machine for it to work. 
It is still necessary to have an administrator account, because the authentication is done by the Kerberos protocol.
No authentication is stored, this is why you will have to authenticate each time you want to launch a module on your servers.

For more informations, you can consult the documentation located in /doc.

## Setup

You can now use pwbrumz with this command:

```
git clone https://github.com/devbosch/pwbrumz
```

## Quick start

Launch the "hello_world" module on a **single server** :

```
powershell.exe main.ps1 -s myserv -m hello_world
```
---
Run "hello_world" module on **multiple windows servers** from config/servers.txt (or whatever name) :

```
powershell.exe main.ps1 -f servers.txt -m hello_world
```
---

Get some informations about specific module :

```
powershell.exe main.ps1 -d hello_world
```
---
List all available modules :
*You can find every modules in /modules and even create your own modules !*

```
powershell.exe main.ps1 -modules
```