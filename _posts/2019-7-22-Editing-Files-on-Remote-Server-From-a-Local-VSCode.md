---
layout: post
title:  "Editing File on a Remote Server From a Local VSCode"
date:   2019-7-28
categories: jekyll update
---

Do you want to leverage the power of VSCode to edit files on a remote server? Me too! Although the VSCode documentation useful, it's encyclopedic and can be a bit hard to follow so I decided to write an abridged guide to setting it up. 

**Warning**
> This guide is meant for Linux/OSX users.
> If you find that you need more information, I'd suggest visiting the original documentation [here](https://code.visualstudio.com/docs/remote/remote-overview).


# Prerequisites/Set-up
1. Since you're reading this, I'll assume you've already downloaded [VSCode](https://code.visualstudio.com/Download).

2. Next up you should get the [Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) extension which allows us to work on remote servers through an SSH connection. It has the capability to connect to servers in other ways, but I'll only discuss connecting through SSH.

3. If you are working on a Linux machine you may also need to install an OpenSSH client.
```bash
sudo apt-get install openssh-client
```

# Configuring Key Based Authentication

First we need to check and make sure we have an SSH key on our local machine. Keys facilitate authentication and are required when using VSCode to edit files on a remote host.

Check to see if you have a file that looks like this `~/ssh/id_rsa.pub`. If not, you can create one using the following command:

```bash
ssh-keygen -t rsa -b 4096
```

Once we have a key, we can add it to our remote host:

```bash
ssh-copy-id jsmith@gateway.flatironinstitute.org
```

You will probably need to enter your credentials here unless you've tinkered with your `~/.ssh/config` file and added some of the features shown below.

With the key in place, we can add some shortcuts to our `~/.ssh/config` file to save time and hassle when using SSH. The example below stores details for logging into the Gateway server at Flatiron in the ssh configuration file (`~/.ssh/config`).

**Warning**
> You will need to change some of the variable values like Hostname and replace them with values appropriate for you. 
> You may also need to remove the comments following the # symbol.

```
 Host flatiron
   Hostname gateway.flatironinstitute.org # change this
   Port 61022
   User jsmith  # change this to your cluster username
   ForwardX11 yes
   ForwardX11Trusted yes          # if you trust us (like -Y)
   DynamicForward 127.0.0.1:61080 # if you want to use Public:Playbooks/ssh_as_a_socks_proxy
   ControlPath ~/.ssh/.%r@%h:%p
   ControlMaster auto             # allows you to connect from other windows without re-authenticating
```
 
With this in my `~/.ssh/config`, if I'm logged onto my remote host in one shell, I can connect to the Gateway server without entering my password using the command `ssh flatiron`.

 # Running on a Remote Host

**Note**
>If you aren't logged on to the remote server you want to connect to, do so now in a terminal window.

Now we can open up VSCode and use the `F1` key or `Crtl+Shift+p` to open the command palette. Type `Remote-SSH: Connect to Host` and VSCode will prompt us to enter something like `username@remotehost.com`. Luckily for us, since we set up those shortcuts earlier, we can just type `flatiron` (or whatever you chose to name your Host in `~/.ssh/config`) and after a few seconds we should be connected. 

**Note**
>The VSCode server on your remote host won't see the extensions you've installed locally so you will need to install them again on the remote host.