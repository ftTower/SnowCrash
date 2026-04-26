# SnowCrash

![banner](https://github.com/ftTower/ftTower/blob/main/assets/Snowcrash/banner.gif)


## VM Configuration :

For this exercice it is recommended to connect with ssh.


To do it the clean way i choosed to use a kali vm on virtualbox.

Here is the configuration :

1. Download the kali package and `open` it with vbox.

2. To create a NAT network on the Vbox main page `Networks > Nat Networks > Create > Choose a name`

![create nat network](https://github.com/ftTower/ftTower/blob/main/assets/Snowcrash/create_nat_network.png)

3. To connect VM to NAT network on the Kali Machine `Settings > Network > 'Attached to : NAT network' > click on the name you choose`

![connect VM to NAT network](https://github.com/ftTower/ftTower/blob/main/assets/Snowcrash/connect_vm_nat_n.png)

4. Start your kali vm and in the terminal allow DHCP using this command :

```shell
sudo bash -c 'cat <<EOF > /etc/network/interfaces
# Network interfaces configuration

source /etc/network/interfaces.d/*

auto lo
iface lo inet loopback

auto enp0s3
iface enp0s3 inet dhcp
EOF'
sudo systemctl restart networking
clear && ip a
```

5. Now you can Open your **SnowCrash** VM, and read the ip on the main page.

6. To connect to SnowCrash VM with ssh use this :

```shell
ssh level00@IP_ADDRESS -p 4242
```

![SSH connected](https://github.com/ftTower/ftTower/blob/main/assets/Snowcrash/ssh_connected.png)


## Commands

### Utils :

```shell
2> /dev/null # hide errors in dev/null
```

### find : 

```shell
cut -d: -f1 /etc/passwd # Looking for all users
```

```shell
find / -user level00 # Looking for all user's files
```