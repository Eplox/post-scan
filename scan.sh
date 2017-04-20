!/bin/bash

if [ -z $1 ]
then
    echo
    echo "Usage : $0 number"

    echo 1: Distribution and kernel version
    echo 2: Mounted filesystems
    echo 3: Network configuration
    echo 4: Development tools availability
    echo 5: Network Connections
    echo 6: Processes
    echo 7: Scheduled jobs
    echo
    echo 8: World writable files
    echo 9: World writable folders
    echo 10: Readable files in /etc
    echo 11: SUID and GUID writable files for $(whoami)
    echo 12: SUID and GUID files
    echo 13: Password and Shadow files
    echo 14: Readable .ssh folders
    echo
    echo 15: Kernel Modules
    echo "16: Installed packages (Ubuntu)"
    echo
    echo 17: Availible shell commands
    echo 18: Availible sudo commands
    echo 19: Record bash history for all users
    echo 99: Tricks and Tips
    exit
fi



case "$1" in
    1)  echo -e "\nDistribution and kernel version\n\n"
        cat /etc/issue
        cat /etc/*-release
        uname -a
        ;;
    2)  echo -e "\nMounted filesystems\n\n"
        mount -l
        ;;
    3)  echo -e "\nNetwork configuration\n\n"
        ifconfig -a
        echo ""
        cat /etc/hosts
        echo ""
        arp
        echo ""
        route -n
        ;;
    4)  echo -e "\nDevelopment tools availability\n\n"
        which gcc
        which g++
        which python
        which ruby
        which perl
        which php
        ;;
    5)  echo -e "\nNetwork Connections\n\n"
        netstat -atulnpe
        ;;
    6)  echo -e "\nProcesses\n\n"
        ps aux
        ;;
    7)  echo -e "\nScheduled jobs\n\n"
        find /etc/cron* -ls 2>/dev/null
        find /var/spool/cron* -ls 2>/dev/null
        ;;
    8)  echo -e "\nWorld writable files"
        find / -perm -2 -type f -ls 2>&1 | grep -v "Permission denied" | grep -v "No such file or directory"
        ;;
    9)  echo -e "\nWorld writable folders"
        find / -perm -2 -type d -ls 2>&1 | grep -v "Permission denied" | grep -v "No such file or directory"
        ;;
    10) echo -e "\nReadable files in /etc\n\n"
        find /etc \( -user `id -u` -perm -u=r -o -group `id -g` -perm -g=r -o -perm -o=r \) -ls 2>&1 | grep -v "Permission denied" | grep -v "No such file or directory"
        ;;
    11) echo -e "\nSUID and GUID writable files for $(whoami)\n\n"
        # Find SUID writable by current user
        find / \( -user `id -u` -perm -u=s -perm -u=w \) -type f -ls 2>&1 | grep -v "Permission denied" | grep -v "No such file or directory"
        # Find GUID writable by current user
        find / \( -group `id -g` -perm -g=s -perm -g=w \) -type f -ls 2>&1  | grep -v "Permission denied" | grep -v "No such file or directory"
        # Find SUID/GUID writable by everyone
        find / \( -perm /u=s,g=s -perm -o=w \) -type f -ls 2>&1  | grep -v "Permission denied" | grep -v "No such file or directory"
        ;;
    12) echo -e "\nSUID and GUID files\n\n"
        find / -type f \( -perm /u=s,g=s \) -ls 2>&1 | grep -v "Permission denied" | grep -v "No such file or directory"
        ;;
    13) echo -e "\nPassword and Shadow files\n\n"
        echo -e "PASSWORD FILES\n\n"
        find / -name '*passw*' 2>&1 -ls | grep -v "Permission denied" | grep -v "/man/" 
        echo -e "\nSHADOW FILES\n\n"
        find / -name '*shadow*' 2>&1 -ls | grep -v "Permission denied" | grep -v "/man/"
        ;;
    14) echo -e "\nReadable .ssh folders"
        find / -name '.ssh' -ls 2>&1 | grep -v "Permission denied"
        ;;
    15) echo -e "\nKernel Modules\n\n"
        lsmod
        ;;
    16) echo -e "\nInstalled packages (Ubuntu)\n\n"
        dpkg -l
        ;;
    17) echo -e "\nAvailible shell commands\n\n"
        compgen -c | sort -u
        ;;
    18) echo -e "\nAvailible sudo commands\n\n"
        sudo -l
        ;;
    19) echo -e "\nRecord bash history for all users\n\n"
        shopt -s histappend
        if [ $? -ne 0 ]; then
            echo "shopt was blocked by sudo"
        else
            echo "shopt enabled"
            echo 
            echo "cat $HOME/.bash_history"
        fi
        ;;
    99) echo -e "\nTricks and tips\n\n"
        echo "ls /etc -la | egrep -e '(shadow)|(passwd)'        # shadow / password files"
        echo "grep -w <IP> /var/log/* -r                        # check logs for your IP"
        echo "cat $HOME/.bash_history                       # check current bash_history"
        echo "$0 8 | grep rwxrwxrwx                      # Find all files with chmod 777 noob permissions"
        echo
        echo "Create a workspace:"
        echo "mkdir  \$(echo -e '\xff\xfd')  \$(echo -e '\xff\xfe') \$(echo -e '\xff\xff') && chmod -r \$(echo -e '\xff*')"
        echo "ln -s /dev/random \$(echo -e '\xff\xfd/\x01') && ln -s /dev/random \$(echo -e '\xff\xfe/\x01') && ln -s /dev/random \$(echo -e '\xff\xff/\x01')    # anti cat *"
        echo "cd \$(echo -e '\xff\xfe')"
        echo
        echo "Delete workspace:"
        echo "chmod +r \$(echo -e '\xff*') && rm -r \$(echo -e '\xff*')"
        echo 
        echo "Other Tools:"
        echo "http://pentestmonkey.net/tools/unix-privesc-check/"
        echo "http://www.securitysift.com/download/linuxprivchecker.py"
        ;;
    *)  echo $1 is not a valid option
        ;;
esac
echo
