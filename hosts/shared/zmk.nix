{ ... }:

{
  services.udev.extraRules = ''
    # ZMK Studio (USB)
    SUBSYSTEM=="usb", ATTR{idVendor}=="1d50", ATTR{idProduct}=="615e", MODE="0666", GROUP="dialout", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
    KERNEL=="ttyACM*", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="615e", MODE="0666", GROUP="dialout", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
  '';
}
