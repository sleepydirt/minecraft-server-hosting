This is a short guide for myself (and anyone else) on how to host your own free Minecraft server with the help of Google Cloud Compute Engine.

Google Cloud offers $300 worth of free credits for 90 days when you sign up with your Google account. A simple Vanilla server will cost about $20 a month to run, so you can run quite large/modded servers by configuring a more powerful VM (since you have $100 free a month)

# Install Java

By default the VM should be empty so you'll need to install Java yourself. For some reason Minecraft 1.21 requires JDK 20 or later, which is not available on apt, so you have to install via Azul.

The great thing about Google Cloud is that you can connect via SSH with a single click from the browser. (no more losing your private keys)

You can also upload and download files directly to/from your computer as well. (no need scp)

Since we are running a Debian VM, install the .deb file JDK on your own computer from https://www.azul.com/core-post-download/ and upload it onto the VM.
```
$ sudo apt install ./(.deb file name)
```
Confirm that Java is installed successfully with ``` java -version ```

# Install the Minecraft Server .jar file

You can find the server.jar file online, copy the link and download it into the VM, it should look something like:
```
$ wget https://launcher.mojang.com/v1/objects/abcdefgh
```

After the install, you can try running the server

```
$ java -Xmx1024M -Xms1024M -jar server.jar nogui
```

Remember to accept the EULA.
```
$ nano eula.txt
```

# Uploading Files to the VM

Now, if you have your own Minecraft world previously that you want to run as a multiplayer server now, you can do so by uploading your own world file into the VM.

Simply locate the directory where your Minecraft world folder is located and delete it first:
```
$ rm world
```

Locate your Minecraft ``` world ``` folder on your local machine and take note of its file path. 
Upload your ``` world ``` folder onto your VM via the command line:
```
$ scp -r /world oci@192.168.0.1:/directory
```
Using the ``` -r ``` argument will cause the command to recursively copy the entire directory and all its files into your VM. Note that your ip address is specific to your VM and directory represents the target directory that your world folder is located in. Enter your password and the transfer should begin. 

# Running a Modded Server on the VM
The features that OCI provides for free is overkill for a simple vanilla Minecraft server. As such, you may want to have mods in your multiplayer server.

Using either a fabric/forge .jar launcher, upload the server jar file into your VM with the same method mentioned above. Run the server once such that the ``` mods ``` folder is generated.

Upload whatever .jar files your mod(s) require into the ``` mods ``` folder onto your VM.

# Copying your Minecraft world from the VM
After you had enough fun playing multiplayer, you can continue your progress on your local machine by copying the ``` world ``` folder back onto your local machine.

Navigate to your ``` .minecraft\saves\ ``` folder and copy the folder path. Copy your files using ``` scp ``` and continue playing on singleplayer!
