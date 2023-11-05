# Nvidia-GPU-Manager
#### This service makes it easy to manage your dedicated NVIDIA GPU.

# Instalation
```shell
curl -LJO https://github.com/DamirDenis-Tudor/Nvidia-GPU-Manager/raw/main/NvidiaGpuManager/ngpum
chmod +x ngpun
sudo mv ngpun /usr/bin/
```

## Prerequisites

1. **Download the NVIDIA Driver:** Start by downloading the NVIDIA driver from [NVIDIA's website](https://www.nvidia.com/download/index.aspx).

2. **Prepare for Installation:**
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

3. **Post-Installation Reboot:** After installation, if you reboot your system, you may encounter issues.

   ![Error Image](https://github.com/DamirDenis-Tudor/Nvidia-GPU-Manager/assets/101417927/6642cb9e-e616-4b07-9d94-de98a2a0b95c)

   This problem arises because the installation process may create the `/etc/X11/xorg.config` file, which may not list your integrated AMD GPU (my case).

4. **Recovery Mode and Config Update:** To resolve this issue, follow these steps:
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

5. **Now you're all set! 😄**

