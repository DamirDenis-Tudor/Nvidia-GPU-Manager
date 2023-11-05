#   Content
##  1) [Description](#description)
##  2) [Instalation](#installation)
##  3) [Usage](#usage)
##  3) [Prerequisites](#prerequisites)

![image](https://github.com/DamirDenis-Tudor/Nvidia-GPU-Manager/assets/101417927/ea280ed4-0177-485e-90a6-c7e44b1c2dfe)


# 1. Nvidia-GPU-Manager <a name="description"></a>
- This service makes it easy to manage your dedicated NVIDIA GPU.
- The way it work is based on binding/unbing the Nvidia GPU device from its drivers.

# 2. Instalation  <a name="installation"></a>
```shell
curl -LJO https://github.com/DamirDenis-Tudor/Nvidia-GPU-Manager/raw/main/NvidiaGpuManager/ngpum.sh
shc -f ngpum.sh -o ngpum; rm ngpum.sh.x.c ngpum.sh;
chmod +x ngpum; sudo mv ngpum /usr/bin/
```

# 3. Usage example  <a name="usage"></a>
- ### Disable GPU
[Screencast from 2023-11-05 13-11-31.webm](https://github.com/DamirDenis-Tudor/Nvidia-GPU-Manager/assets/101417927/bd74a0cf-5d17-4aea-9602-86cf14b46805)

<br>

- ### Enagle GPU
[Screencast from 2023-11-05 13-12-27.webm](https://github.com/DamirDenis-Tudor/Nvidia-GPU-Manager/assets/101417927/76f0d3cb-4965-441d-853b-68d63910cabd)

<br>

- ### Disable again GPU
[Screencast from 2023-11-05 13-13-20.webm](https://github.com/DamirDenis-Tudor/Nvidia-GPU-Manager/assets/101417927/303c0291-fd26-4b7a-a0df-776eaab285ce)

<br>

# 4. Prerequisites <a name="prerequisites"></a>

### 1. **Download the NVIDIA Driver:** Start by downloading the NVIDIA driver from [NVIDIA's website](https://www.nvidia.com/download/index.aspx).

### 2. **Prepare for Installation:**
   - X server should be off.
     ```shell
     Using: nvidia-installer ncurses v6 user interface
          -> Detected 16 CPUs online; setting concurrency level to 16.
          -> The file '/tmp/.X0-lock' exists and appears to contain the process ID '11631' of a running X server.
      ERROR: You appear to be running an X server; please exit X before installing. For further details, please see the section INSTALLING THE NVIDIA DRIVER in the README available on the Linux driver download page at [www.nvidia.com](https://www.nvidia.com).
      ERROR: Installation has failed. Please see the file '/var/log/nvidia-installer.log' for details. You may find suggestions on fixing installation problems in the README available on the Linux driver download page at [www.nvidia.com](https://www.nvidia.com).
     ```
   - To proceed over this issue, you must enter in `multi-user mode without GUI` with the command:
     ```shell
     sudo telinit 3
     ```
   - Stop your display manager service (e.g., `lightdm` or `gdm`) with the following command:
     ```shell
     sudo service gdm stop
     ```
   - Install any necessary libraries if prompted. An example error message may look like this:
     ```shell
     ERROR: Unable to find the development tool 'cc' in your path; please make sure that you have the 'gcc' package installed. If 'gcc' is installed, check that 'cc' is in your PATH.
     ```

### 3. **Post-Installation Reboot:** After installation, if you reboot your system, you may encounter issues.

   ![Error Image](https://github.com/DamirDenis-Tudor/Nvidia-GPU-Manager/assets/101417927/6642cb9e-e616-4b07-9d94-de98a2a0b95c)

   This problem arises because the installation process may create the `/etc/X11/xorg.config` file, which may not list your integrated AMD GPU (my case).

### 4. **Recovery Mode and Config Update:** To resolve this issue, follow these steps:
   - Reboot your system in recovery mode, allowing you to log in as the root user.
   - Check for your AMD GPU (my case) PCI ID, e.g., `04:00.0`, using this command:
     ```shell
     lspci | grep VGA
     01:00.0 VGA compatible controller: NVIDIA Corporation TU117M [GeForce GTX 1650 Mobile / Max-Q] (rev a1)
     04:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Cezanne [Radeon Vega Series / Radeon Vega Mobile Series] (rev c5)
     ```
   - Open the `/etc/X11/xorg.conf` file. You may only see the Nvidia device listed.

   ![Nvidia Device Image](https://github.com/DamirDenis-Tudor/Nvidia-GPU-Manager/assets/101417927/91d0963e-2bb0-48c9-9b7c-b8daa1867a7f)

   - Add a new device entry with the corresponding BusID.

   ![New Device Image](https://github.com/DamirDenis-Tudor/Nvidia-GPU-Manager/assets/101417927/bddc0640-ed69-40e3-a905-91e19f5deb08)

   - If you cannot find `/etc/X11/xorg.conf`, refer to [this link](https://www.x.org/releases/current/doc/man/man5/xorg.conf.5.xhtml) for further guidance.

### 5. **Now you're all set! 😄**

