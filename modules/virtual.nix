{ pkgs, config, username, ... }:
# {
# 
#   programs.virt-manager = {
#     enable = true;
#     package = pkgs.virt-manager;
#   };
# }

# virtualization.nix
# { config, lib, pkgs, ... }:

{
  # Enable virtualization support
  virtualisation = {
    # Enable libvirt daemon
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          })];
        };
      };
    };
    
    # Enable spiceUSBRedirection for better USB device support
    spiceUSBRedirection.enable = true;

    # Configure podman as a lightweight alternative to Docker
    podman = {
      enable = true;
      # dockerCompat = true; # Docker command compatibility
      defaultNetwork.settings.dns_enabled = true;
    };
    
  };

  # Install necessary packages for VM management
  environment.systemPackages = with pkgs; [
    # VM management tools
    virt-manager
    virt-viewer
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
    swtpm
    
    # Network tools
    bridge-utils
    dnsmasq
    
    # Container tools
    docker-compose
    podman-compose
    distrobox
  ];

  # Allow management of libvirt through polkit for Hyprland
  security.polkit.enable = true;
  
  # Enable necessary services
  systemd.services.libvirtd.enable = true;
  
  # Add user to libvirt group
  users.users.${username}.extraGroups = [ "libvirtd" "qemu-libvirtd" "kvm" "docker" ];
  
  # Network configuration for VMs
  networking = {
    firewall = {
      allowedTCPPorts = [ 22 80 443 8080 ];
      # Trust traffic from the VM subnet
      trustedInterfaces = [ "virbr0" ];
    };
    
    # Optional: Create a bridge for VMs if needed
    bridges = {
      br0 = {
        interfaces = [ "eth0" ]; # Change to your actual interface
      };
    };
  };
  
}
