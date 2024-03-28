This is a short guide for myself (and anyone else) on how to host your own free Minecraft server with the help of Oracle Cloud Infrastructure (OCI).

You can find the details on how to create your own OCI account and create a new VM instance on the Oracle website, just google it

# Install Java

By default the VM should be empty so you'll need to install Java yourself. 
```
yum list jdk
sudo yum install (jdk version)
```
Confirm that Java is installed successfully with ``` java --version ```

# Install the Minecraft Server .jar file

You can find the server.jar file online, copy the link and download it into the VM, it should look something like:
```
wget https://launcher.mojang.com/v1/objects/abcdefgh
```

After the install, you can try running the server

```
java -Xmx1024M -Xms1024M -jar server.jar nogui
```

Remember to accept the EULA.
```
nano eula.txt
```

# Uploading Files to the VM

Now, if you have your own Minecraft world previously that you want to run as a multiplayer server now, you can do so by uploading your own world file into the VM.

Simply locate the directory where your Minecraft world folder is located and delete it first:
```
rm world
```


