# Linux Commands Master List for Scenario Generation

**Purpose:** Comprehensive command inventory to ensure complete coverage in training dataset.  
**Strategy:** Generate 2-3 real-world scenarios per command, organized by category.  
**Target:** 500-1000 commands → 1500-3000 training examples

---

## 1. FILE OPERATIONS (80 commands)

### Basic Navigation & Viewing
- `ls` - list directory contents (with -la, -lh, -R, --color)
- `cd` - change directory
- `pwd` - print working directory
- `tree` - display directory structure
- `cat` - concatenate and display files
- `less` - view file with pagination
- `more` - simple file viewer
- `head` - view first lines of file
- `tail` - view last lines of file (with -f for follow)
- `bat` - cat with syntax highlighting
- `file` - determine file type
- `stat` - display file statistics
- `touch` - create empty file or update timestamp

### File Manipulation
- `cp` - copy files/directories
- `mv` - move or rename files
- `rm` - remove files/directories
- `mkdir` - make directory
- `rmdir` - remove empty directory
- `ln` - create links (hard/symbolic)
- `readlink` - resolve symbolic links
- `realpath` - print absolute path
- `basename` - strip directory from path
- `dirname` - extract directory from path
- `mktemp` - create temporary file/directory
- `dd` - convert and copy files (low-level)
- `truncate` - shrink or extend file size
- `shred` - securely delete file
- `rename` - batch rename files
- `mmv` - mass move/rename with patterns

### File Searching
- `find` - search for files in directory hierarchy
- `locate` - find files by name (uses database)
- `updatedb` - update locate database
- `which` - locate command executable
- `whereis` - locate binary, source, and manual page
- `type` - display command type
- `mlocate` - secure locate alternative

### File Content Search & Processing
- `grep` - search text patterns (with -r, -i, -v, -E, -P)
- `egrep` - extended grep
- `fgrep` - fixed-string grep
- `ripgrep` / `rg` - fast recursive grep
- `ag` - the silver searcher
- `ack` - grep alternative for programmers
- `zgrep` - grep compressed files
- `strings` - extract printable strings from binary
- `hexdump` - hex viewer
- `xxd` - hex dump with reverse capability
- `od` - octal dump

### File Comparison & Diff
- `diff` - compare files line by line
- `sdiff` - side-by-side diff
- `vimdiff` - vim with diff mode
- `cmp` - compare files byte by byte
- `comm` - compare sorted files
- `patch` - apply diff patch
- `diffstat` - statistics from diff

### File Permissions & Ownership
- `chmod` - change file permissions
- `chown` - change file owner
- `chgrp` - change group ownership
- `umask` - set default permissions
- `chattr` - change file attributes (immutable, etc.)
- `lsattr` - list file attributes
- `getfacl` - get file ACLs
- `setfacl` - set file ACLs
- `namei` - follow pathname to inode

### File System Operations
- `df` - disk free space
- `du` - disk usage (directory sizes)
- `ncdu` - ncurses disk usage analyzer
- `lsblk` - list block devices
- `blkid` - locate/print block device attributes
- `findmnt` - find mounted filesystems
- `mount` - mount filesystem
- `umount` - unmount filesystem
- `sync` - flush filesystem buffers
- `fsck` - filesystem check/repair
- `e2fsck` - ext2/3/4 filesystem check
- `xfs_repair` - XFS filesystem repair
- `btrfs` - btrfs filesystem management
- `mkfs` - make filesystem
- `tune2fs` - adjust ext filesystem parameters
- `dumpe2fs` - dump ext filesystem info

---

## 2. SYSTEM MANAGEMENT (120 commands)

### System Information
- `uname` - print system information
- `hostname` - show/set hostname
- `hostnamectl` - control hostname (systemd)
- `uptime` - show uptime and load average
- `who` - show logged-in users
- `w` - show who is logged in and what they're doing
- `whoami` - print current user
- `id` - print user/group IDs
- `last` - show last logged in users
- `lastb` - show failed login attempts
- `lastlog` - show most recent logins
- `users` - print usernames of logged-in users
- `groups` - show group memberships
- `lsb_release` - show distribution information
- `neofetch` - system info with ASCII art
- `screenfetch` - neofetch alternative
- `inxi` - comprehensive system information
- `hwinfo` - hardware information

### Process Management
- `ps` - process status (with aux, -ef, --forest)
- `top` - dynamic process viewer
- `htop` - interactive process viewer
- `btop` - resource monitor (modern)
- `atop` - advanced system monitor
- `pgrep` - find processes by name
- `pkill` - kill processes by name
- `pidof` - find PID of running program
- `pstree` - display process tree
- `kill` - send signal to process
- `killall` - kill processes by name
- `nice` - run with modified priority
- `renice` - change priority of running process
- `ionice` - set I/O scheduling priority
- `nohup` - run immune to hangups
- `bg` - send to background
- `fg` - bring to foreground
- `jobs` - list background jobs
- `disown` - remove job from shell
- `screen` - terminal multiplexer
- `tmux` - terminal multiplexer (modern)
- `watch` - execute command periodically

### Systemd & Service Management
- `systemctl` - control systemd system/services
- `journalctl` - query systemd journal
- `systemd-analyze` - analyze boot time
- `systemd-cgls` - show cgroup tree
- `systemd-cgtop` - cgroup resource monitor
- `loginctl` - control systemd login manager
- `timedatectl` - control time/date settings
- `localectl` - control locale settings
- `hostnamectl` - control hostname
- `coredumpctl` - access core dumps
- `busctl` - D-Bus introspection
- `systemd-resolve` - resolve domain names
- `resolvectl` - resolve domain names (newer)
- `systemd-inhibit` - inhibit sleep/shutdown

### Init Systems (legacy/alternative)
- `service` - run init script
- `chkconfig` - system services management (Red Hat)
- `update-rc.d` - install/remove init scripts (Debian)
- `rc-service` - OpenRC service management
- `rc-update` - OpenRC runlevel management

### Resource Monitoring
- `free` - memory usage
- `vmstat` - virtual memory statistics
- `iostat` - I/O statistics
- `mpstat` - CPU statistics
- `sar` - system activity reporter
- `dstat` - versatile resource statistics
- `iotop` - I/O usage by process
- `iftop` - network bandwidth by connection
- `nethogs` - network bandwidth by process
- `nload` - network traffic visualization
- `bmon` - bandwidth monitor
- `vnstat` - network statistics daemon
- `glances` - cross-platform monitoring tool
- `nmon` - performance monitoring

### Performance & Tuning
- `cpupower` - CPU frequency scaling
- `powertop` - power consumption analysis
- `tuned` - system tuning daemon
- `tuned-adm` - tuned profile management
- `sysctl` - configure kernel parameters
- `ulimit` - user resource limits
- `prlimit` - get/set resource limits
- `taskset` - CPU affinity
- `chrt` - real-time scheduling
- `perf` - performance analysis
- `strace` - trace system calls
- `ltrace` - library call tracer
- `lsof` - list open files
- `fuser` - identify processes using files
- `lslocks` - list file locks

### Power Management
- `shutdown` - shutdown/reboot system
- `reboot` - reboot system
- `poweroff` - power off system
- `halt` - halt system
- `suspend` - suspend to RAM
- `hibernate` - suspend to disk
- `pm-suspend` - power management suspend
- `systemctl suspend` - systemd suspend
- `systemctl hibernate` - systemd hibernate

### Time & Scheduling
- `date` - print/set system date
- `timedatectl` - control time settings
- `hwclock` - hardware clock
- `cal` - calendar
- `cron` - job scheduler daemon
- `crontab` - schedule cron jobs
- `at` - schedule one-time job
- `atq` - list scheduled at jobs
- `atrm` - remove at job
- `batch` - execute when load permits
- `anacron` - periodic command scheduler

---

## 3. NETWORK (100 commands)

### Network Configuration
- `ip` - show/manipulate routing, devices (addr, link, route, neigh)
- `ifconfig` - configure network interface (legacy)
- `ifup` - bring interface up
- `ifdown` - bring interface down
- `nmcli` - NetworkManager CLI
- `nmtui` - NetworkManager TUI
- `netplan` - network configuration (Ubuntu)
- `netctl` - network profile manager (Arch)
- `systemd-networkd` - systemd network management
- `dhclient` - DHCP client
- `dhcpcd` - DHCP client daemon
- `iw` - wireless configuration
- `iwconfig` - wireless configuration (legacy)
- `iwlist` - list wireless info
- `rfkill` - enable/disable wireless

### Network Testing & Diagnostics
- `ping` - test network connectivity
- `ping6` - ping IPv6
- `traceroute` - trace packet route
- `tracepath` - trace path to host
- `mtr` - network diagnostic tool (ping + traceroute)
- `arping` - ARP ping
- `fping` - ping multiple hosts
- `hping3` - advanced ping
- `nmap` - network scanner
- `netcat` / `nc` - network swiss army knife
- `socat` - multipurpose relay
- `telnet` - telnet client
- `netstat` - network statistics (legacy)
- `ss` - socket statistics (modern netstat)
- `lsof -i` - list network connections
- `iftop` - bandwidth monitor
- `nethogs` - per-process bandwidth
- `tcpdump` - packet analyzer
- `wireshark` - GUI packet analyzer
- `tshark` - terminal wireshark
- `ethtool` - ethernet settings
- `mii-tool` - media-independent interface tool

### DNS & Name Resolution
- `dig` - DNS lookup
- `nslookup` - DNS query
- `host` - DNS lookup
- `getent` - get entries from databases
- `resolvectl` - resolve domains
- `systemd-resolve` - resolve domains (legacy)
- `drill` - DNS tool (ldns)
- `whois` - whois lookup
- `nmap --script dns-*` - DNS scripts

### Routing
- `route` - show/manipulate routing table (legacy)
- `ip route` - modern routing commands
- `iptables` - IPv4 packet filtering
- `ip6tables` - IPv6 packet filtering
- `nftables` - modern packet filtering
- `ufw` - uncomplicated firewall
- `firewalld` - firewall daemon
- `firewall-cmd` - firewalld management

### File Transfer
- `wget` - download files
- `curl` - transfer data with URLs
- `aria2c` - download utility
- `rsync` - sync files/directories
- `scp` - secure copy
- `sftp` - secure FTP
- `ftp` - FTP client
- `lftp` - sophisticated FTP client
- `rclone` - sync to cloud storage
- `rcp` - remote copy (legacy)

### Remote Access
- `ssh` - secure shell
- `ssh-keygen` - generate SSH keys
- `ssh-copy-id` - copy SSH key to remote
- `ssh-add` - add key to agent
- `ssh-agent` - SSH authentication agent
- `sshd` - SSH daemon
- `sshfs` - mount filesystem over SSH
- `mosh` - mobile shell (better SSH)
- `autossh` - automatically restart SSH
- `x11vnc` - VNC server for X11
- `vncviewer` - VNC client
- `rdesktop` - RDP client
- `xfreerdp` - FreeRDP client

### Network Shares
- `mount.cifs` - mount SMB/CIFS share
- `mount.nfs` - mount NFS share
- `smbclient` - SMB client
- `nmblookup` - NetBIOS name lookup
- `showmount` - show NFS exports
- `exportfs` - maintain NFS exports
- `nfs-server` - NFS server control

### Network Services
- `systemctl start/stop <service>` - manage network services
- `apache2ctl` / `httpd` - Apache control
- `nginx` - nginx web server
- `docker` - container management
- `docker-compose` - multi-container orchestration

---

## 4. PACKAGE MANAGEMENT (60 commands)

### Debian/Ubuntu (APT)
- `apt` - package management
- `apt-get` - APT package handling
- `apt-cache` - APT cache operations
- `apt-file` - search files in packages
- `dpkg` - Debian package manager
- `dpkg-query` - query dpkg database
- `dpkg-reconfigure` - reconfigure package
- `update-alternatives` - manage alternatives
- `add-apt-repository` - add PPA
- `apt-key` - manage APT keys
- `aptitude` - text-based package manager

### Red Hat/Fedora (DNF/YUM)
- `dnf` - Dandified YUM
- `yum` - package manager
- `rpm` - RPM package manager
- `yum-config-manager` - manage yum config
- `dnf search` - search packages
- `rpm -qa` - list installed packages
- `rpm -ql` - list package files
- `rpm -qf` - find package owning file
- `createrepo` - create RPM repository

### Arch Linux (Pacman)
- `pacman` - package manager (-S, -R, -Q, -Ss, -Syu)
- `yay` - AUR helper
- `paru` - AUR helper (rust)
- `makepkg` - build packages from source
- `pacman-key` - manage pacman keys
- `paccache` - clean package cache
- `pkgfile` - search files in packages

### Universal Package Managers
- `snap` - Snap package manager
- `flatpak` - Flatpak package manager
- `appimage` - AppImage management
- `nix` - Nix package manager
- `brew` - Homebrew (Linux)

### Language-Specific
- `pip` - Python package installer
- `pip3` - Python 3 package installer
- `pipx` - install Python apps
- `npm` - Node.js package manager
- `yarn` - alternative Node.js package manager
- `pnpm` - fast Node.js package manager
- `gem` - Ruby package manager
- `cargo` - Rust package manager
- `go get` - Go package manager
- `composer` - PHP dependency manager

### Build Tools
- `make` - build automation
- `cmake` - cross-platform make
- `configure` - configure source for building
- `gcc` - GNU C compiler
- `g++` - GNU C++ compiler
- `clang` - LLVM C compiler
- `rustc` - Rust compiler
- `javac` - Java compiler

---

## 5. USER & PERMISSIONS (50 commands)

### User Management
- `useradd` - create user
- `adduser` - create user (interactive)
- `userdel` - delete user
- `usermod` - modify user
- `passwd` - change password
- `chpasswd` - batch password changes
- `pwck` - verify password file
- `vipw` - edit password file safely

### Group Management
- `groupadd` - create group
- `groupdel` - delete group
- `groupmod` - modify group
- `gpasswd` - administer groups
- `newgrp` - change current group
- `groups` - show user groups
- `vigr` - edit group file safely

### Permissions & Access
- `chmod` - change file permissions
- `chown` - change owner
- `chgrp` - change group
- `umask` - set default permissions
- `sudo` - execute as superuser
- `su` - switch user
- `visudo` - edit sudoers file
- `sudoedit` - edit file as superuser

### Access Control
- `setfacl` - set file ACLs
- `getfacl` - get file ACLs
- `chattr` - change file attributes
- `lsattr` - list file attributes
- `setenforce` - set SELinux mode
- `getenforce` - get SELinux mode
- `semanage` - SELinux management
- `restorecon` - restore SELinux context
- `chcon` - change SELinux context
- `aa-status` - AppArmor status
- `aa-complain` - set AppArmor to complain mode
- `aa-enforce` - set AppArmor to enforce mode

### Session Management
- `login` - log into system
- `logout` - log out
- `exit` - exit shell
- `who` - show logged-in users
- `w` - show who and what they're doing
- `last` - show login history
- `loginctl` - control login manager

---

## 6. TEXT PROCESSING (70 commands)

### Text Viewing & Editing
- `cat` - concatenate files
- `tac` - cat in reverse
- `less` - pager
- `more` - simple pager
- `head` - first lines
- `tail` - last lines
- `vim` - text editor
- `nano` - simple editor
- `emacs` - extensible editor
- `ed` - line editor
- `sed` - stream editor
- `awk` - pattern scanning
- `tr` - translate characters
- `cut` - cut fields
- `paste` - merge lines
- `column` - columnate lists
- `nl` - number lines
- `wc` - word count
- `fold` - wrap lines

### Text Searching & Filtering
- `grep` - search patterns
- `egrep` - extended grep
- `fgrep` - fixed grep
- `zgrep` - grep gzipped files
- `ag` - silver searcher
- `rg` - ripgrep
- `ack` - programmer grep

### Text Sorting & Uniqueness
- `sort` - sort lines
- `uniq` - remove duplicates
- `comm` - compare sorted files
- `join` - join lines by field
- `shuf` - shuffle lines
- `tsort` - topological sort

### Text Transformation
- `sed` - stream editing
- `awk` - pattern processing
- `tr` - translate/delete characters
- `expand` - tabs to spaces
- `unexpand` - spaces to tabs
- `rev` - reverse lines
- `tac` - reverse file
- `fmt` - format text
- `pr` - format for printing

### Text Encoding & Conversion
- `iconv` - convert encoding
- `dos2unix` - convert line endings
- `unix2dos` - convert to DOS format
- `base64` - base64 encode/decode
- `uuencode` - encode file
- `uudecode` - decode file
- `hexdump` - hex view
- `xxd` - hex dump

### Regular Expressions & Advanced
- `perl -ne` - Perl one-liners
- `python -c` - Python one-liners
- `ruby -e` - Ruby one-liners
- `jq` - JSON processor
- `yq` - YAML processor
- `xmllint` - XML tool
- `xsltproc` - XSLT processor

### Checksums & Hashing
- `md5sum` - MD5 checksum
- `sha1sum` - SHA1 checksum
- `sha256sum` - SHA256 checksum
- `sha512sum` - SHA512 checksum
- `cksum` - CRC checksum
- `b2sum` - BLAKE2 checksum

---

## 7. ARCHIVE & COMPRESSION (30 commands)

### TAR Archives
- `tar` - archive utility (with -czf, -xzf, -tzf)
- `tar cvf` - create archive
- `tar xvf` - extract archive
- `tar tvf` - list archive contents
- `tar czf` - create gzipped tar
- `tar cjf` - create bzip2'd tar
- `tar cJf` - create xz'd tar

### Compression
- `gzip` - compress files
- `gunzip` - decompress gzip
- `zcat` - view compressed file
- `bzip2` - compress with bzip2
- `bunzip2` - decompress bzip2
- `bzcat` - view bzip2 file
- `xz` - compress with xz
- `unxz` - decompress xz
- `xzcat` - view xz file
- `compress` - compress (legacy)
- `uncompress` - decompress (legacy)
- `zstd` - Zstandard compression
- `lz4` - LZ4 compression

### ZIP Archives
- `zip` - create zip archive
- `unzip` - extract zip archive
- `zipinfo` - zip file information
- `7z` - 7-Zip archiver
- `rar` - RAR archiver
- `unrar` - extract RAR

### Other Archive Tools
- `ar` - archive library files
- `cpio` - copy files to/from archives
- `pax` - portable archive exchange

---

## 8. DEVELOPMENT & DEBUGGING (80 commands)

### Version Control (Git)
- `git` - version control
- `git init` - initialize repository
- `git clone` - clone repository
- `git add` - stage changes
- `git commit` - commit changes
- `git push` - push to remote
- `git pull` - pull from remote
- `git status` - check status
- `git log` - view history
- `git diff` - show differences
- `git branch` - manage branches
- `git checkout` - switch branches
- `git merge` - merge branches
- `git rebase` - rebase commits
- `git stash` - stash changes
- `git reset` - reset commits
- `git revert` - revert commits
- `git tag` - tag versions
- `git remote` - manage remotes
- `git config` - configure git

### Compilers & Build
- `gcc` - C compiler
- `g++` - C++ compiler
- `clang` - LLVM compiler
- `make` - build tool
- `cmake` - cross-platform build
- `automake` - generate Makefiles
- `autoconf` - configure scripts
- `libtool` - library creation
- `pkg-config` - library metadata
- `ld` - linker
- `ar` - create libraries
- `ranlib` - library index
- `strip` - remove symbols
- `objdump` - object file info
- `nm` - list symbols
- `readelf` - ELF file info
- `ldd` - print shared dependencies

### Debugging
- `gdb` - GNU debugger
- `lldb` - LLVM debugger
- `strace` - trace system calls
- `ltrace` - trace library calls
- `valgrind` - memory debugger
- `gprof` - profiler
- `perf` - performance analysis
- `ftrace` - function tracer
- `addr2line` - convert address to line
- `gcore` - generate core dump

### Development Tools
- `ctags` - generate tags
- `cscope` - source code browser
- `indent` - format C code
- `astyle` - code formatter
- `clang-format` - format code
- `shellcheck` - shell script linter
- `pylint` - Python linter
- `flake8` - Python style checker
- `black` - Python formatter
- `mypy` - Python type checker
- `eslint` - JavaScript linter
- `prettier` - code formatter

### Python Development
- `python` - Python interpreter
- `python3` - Python 3 interpreter
- `pip` - package installer
- `virtualenv` - virtual environments
- `venv` - virtual environment (built-in)
- `poetry` - dependency management
- `pytest` - testing framework
- `ipython` - interactive Python
- `jupyter` - Jupyter notebooks

### Container & Virtualization
- `docker` - container platform
- `docker-compose` - multi-container
- `podman` - daemonless containers
- `buildah` - build OCI images
- `kubectl` - Kubernetes CLI
- `vagrant` - VM management
- `virsh` - libvirt management
- `virt-manager` - VM GUI
- `qemu` - machine emulator
- `kvm` - kernel virtual machine

---

## 9. HARDWARE & DEVICES (50 commands)

### Hardware Information
- `lscpu` - CPU information
- `lshw` - hardware lister
- `lspci` - list PCI devices
- `lsusb` - list USB devices
- `lsblk` - list block devices
- `lsscsi` - list SCSI devices
- `dmidecode` - DMI table decoder
- `hwinfo` - hardware info
- `inxi` - system information
- `sensors` - hardware sensors
- `sensors-detect` - detect sensors
- `acpi` - ACPI information
- `upower` - power management

### Disk & Storage
- `fdisk` - partition table manipulator
- `gdisk` - GPT partition editor
- `parted` - partition editor
- `cfdisk` - curses fdisk
- `mkfs` - make filesystem
- `mkswap` - make swap
- `swapon` - enable swap
- `swapoff` - disable swap
- `mount` - mount filesystem
- `umount` - unmount filesystem
- `blkid` - block device IDs
- `findmnt` - find mounts
- `df` - disk free
- `du` - disk usage
- `hdparm` - disk parameters
- `sdparm` - SCSI disk parameters
- `smartctl` - SMART disk info
- `badblocks` - check for bad blocks
- `ddrescue` - data recovery
- `testdisk` - partition recovery
- `photorec` - file recovery

### USB & Devices
- `usbview` - USB device viewer
- `usb-devices` - list USB devices
- `udevadm` - udev management
- `lsmod` - list modules
- `modprobe` - load/unload modules
- `insmod` - insert module
- `rmmod` - remove module
- `modinfo` - module information
- `depmod` - module dependencies

### Graphics & Display
- `xrandr` - X display config
- `xdpyinfo` - X display info
- `xwininfo` - window info
- `nvidia-smi` - NVIDIA GPU info
- `intel_gpu_top` - Intel GPU monitor
- `radeontop` - AMD GPU monitor
- `glxinfo` - OpenGL info
- `vulkaninfo` - Vulkan info

---

## 10. SECURITY & ENCRYPTION (40 commands)

### Encryption
- `gpg` - GNU Privacy Guard
- `openssl` - SSL/TLS toolkit
- `ssh-keygen` - generate SSH keys
- `age` - simple encryption
- `encfs` - encrypted filesystem
- `cryptsetup` - LUKS encryption
- `veracrypt` - disk encryption

### Security Scanning
- `nmap` - network scanner
- `lynis` - security auditing
- `rkhunter` - rootkit hunter
- `chkrootkit` - check for rootkits
- `clamav` - antivirus scanner
- `aide` - file integrity checker
- `tripwire` - intrusion detection

### Firewall
- `iptables` - packet filtering
- `ip6tables` - IPv6 filtering
- `nftables` - modern firewall
- `ufw` - uncomplicated firewall
- `firewalld` - firewall daemon
- `fail2ban` - ban IPs after failures

### Access & Authentication
- `sudo` - superuser do
- `su` - switch user
- `pam` - pluggable auth modules
- `authconfig` - auth configuration
- `kerberos` - network authentication
- `ldap` - directory services

### Auditing
- `auditctl` - audit system
- `ausearch` - search audit logs
- `aureport` - audit reports
- `lastlog` - last logins
- `lastb` - failed logins
- `faillog` - failure logs
- `who` - logged in users
- `w` - who and what

---

**Total Commands:** ~680 commands across 10 categories  
**Expected Scenarios:** 1360-2040 (2-3 per command)  
**With Foundation:** 1405-2085 total examples

---

## Generation Strategy:

1. **Per Command Generate:**
   - Common use case scenario
   - Troubleshooting scenario (when command fails/used for diagnosis)
   - Advanced/edge case scenario (optional, for complex commands)

2. **Include:**
   - Related commands (command web)
   - Common flags/options
   - Error scenarios
   - Both Ubuntu/Debian AND Arch Linux examples

3. **Priority:**
   - High: Daily-use commands (top, systemctl, ip, grep, etc.)
   - Medium: Troubleshooting commands (strace, tcpdump, etc.)
   - Low: Specialized commands (rarely used but important to cover)
