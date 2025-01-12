This is a short guide for myself (and anyone else) on how to host your own free Minecraft server with the help of Google Cloud Platform (or any other virtual machine, really).

Google Cloud offers $300 worth of free credits for 90 days when you sign up with your Google account. A simple Vanilla server will cost about $20 a month to run, so you can run quite large/modded servers by configuring a more powerful VM. This only lasts for 3 months, so you will have to make a new Google account and port your world over in order to continue.

# Setup
For a simple Minecraft 1.21 server, you can run `setup.sh` to quickly set up a Vanliia server.

## 1. Clone the repository
```
git clone https://github.com/sleepydirt/minecraft-server-hosting.git
cd minecraft-server-hosting
```

## 2. Run the setup script
```
sudo ./setup.sh
```

## 3. Start the server
By default, a new directory `minecraft` is created under the directory that the script is run in.
```
cd ./minecraft && java -Xmx1024M -Xms1024M -jar server.jar nogui
```

# Install Java

By default the VM should be empty so you'll need to install Java yourself. Minecraft 1.21 requires JDK 20 or later.

The great thing about Google Cloud is that you can connect via SSH with a single click from the browser, which is much easier than using the command line.

You can also upload and download files directly to/from your computer as well, which eliminates the need for `scp`.

Install the latest version of JDK from https://www.oracle.com/java/technologies/javase/jdk22-archive-downloads.html onto your VM.
```
wget https://download.oracle.com/java/22/archive/jdk-22.0.1_linux-x64_bin.deb
sudo apt install ./jdk-22.0.1_linux-x64_bin.deb
```
Confirm that Java is installed successfully with ``` java -version ```

![image](https://github.com/user-attachments/assets/a6159980-dc75-4dde-9eac-3655996eb371)

# Install the Minecraft Server .jar file

For earlier/later Minecraft versions, you can find the server.jar file online, copy the link and download it into the VM.
For Minecraft 1.21, run:
```
wget https://piston-data.mojang.com/v1/objects/450698d1863ab5180c25d7c804ef0fe6369dd1ba/server.jar
```

After the install, you can run the server

```
java -Xmx1024M -Xms1024M -jar server.jar nogui
```

Remember to accept the EULA.
```
nano eula.txt
```

# Uploading Files to the VM

Now, if you have your own Minecraft world previously that you want to run as a multiplayer server, you can do so by uploading your own world file into the VM.

Simply locate the directory where your Minecraft world folder is located and delete it first:
```
rm world
```

Locate your Minecraft ``` world ``` folder on your local machine and take note of its file path. 

With Google Cloud Platform, you are able to drag and drop files directly into your VM. Simply upload your entire ```world``` folder into the VM and move it to the directory as the Minecraft server installation.

![image](https://github.com/user-attachments/assets/1825a590-adb4-45e8-b774-e49fbcf91bcc)

# If you are using another provider
Upload your ``` world ``` folder onto your VM via the command line:
```
scp -r /world root@xx.xx.xx.x:/directory
```
Using the ``` -r ``` argument will cause the command to recursively copy the entire directory and all its files into your VM. Note that your ip address is specific to your VM and directory represents the target directory that your world folder is located in. Enter your password and the transfer should begin. 

# Keeping your server running 24/7

Your server will stop once you close the Terminal window. To keep your server running 24/7, we can use ``` Screen ```.

You can install screen with
```
sudo apt-get install screen
```

First, create a new Screen named Minecraft and run your server.jar file within it. You can specify the amount of RAM to be allocated to the server, which is typically ~80% of your VM's total memory.

``` 
screen -mdS minecraft java -Xms2G -Xmx2G -jar server.jar
```

To detach from your screen, press ```Ctrl+A``` + ```D```, and to reopen your screen do

```
screen -x minecraft
```

# Running a Modded Server on the VM
The features that GCP provides for free is overkill for a simple vanilla Minecraft server. As such, you may want to have mods in your multiplayer server.

Using either a fabric/forge .jar launcher, upload the server jar file into your VM with the same method mentioned above. Run the server once such that the ``` mods ``` folder is generated.

Upload whatever .jar files your mod(s) require into the ``` mods ``` folder onto your VM.

You can also use pre-configured server packs from ```CurseForge``` that will be much easier to set up at the cost of some customisability.

# Copying your Minecraft world from the VM
After you had enough fun playing multiplayer, you can continue your progress on your local machine by copying the ``` world ``` folder back onto your local machine.

With Google Cloud, you can simply click `Download File`, and enter the ```world``` file path. 

Else, navigate to your ``` .minecraft\saves\ ``` folder and copy the folder path. Copy your files using ``` scp ``` and continue playing on singleplayer.
