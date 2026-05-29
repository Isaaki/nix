{ ... }:

{
  services.udev.extraRules = ''
    # ZMK Studio (USB)
    SUBSYSTEM=="usb", ATTR{idVendor}=="1d50", ATTR{idProduct}=="615e", MODE="0666", GROUP="dialout", TAG+="uaccess"
    KERNEL=="ttyACM*", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="615e", MODE="0666", GROUP="dialout", TAG+="uaccess"
  '';
}
