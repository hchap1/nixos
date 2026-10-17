{ config, ... }:

{
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
    # WebKitGTK's DMA-BUF renderer crashes (Wayland protocol error 71) on
    # NVIDIA under wlroots compositors like Hyprland. Affects any
    # webkit2gtk-based app, e.g. Modrinth App (Tauri).
    WEBKIT_DISABLE_DMABUF_RENDERER = "1";
  };
}
