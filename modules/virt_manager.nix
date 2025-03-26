{ pkgs, username, ... }:
{
  virtualisation.libvirtd = {
    enable = true;
    qemu.ovmf = {
      enable = true;
      packages = [
        pkgs.pkgsCross.aarch64-multiplatform.OVMF.fd
        pkgs.OVMFFull.fd
      ];
    };
  };
  programs.virt-manager.enable = true;
  users.users.${username}.extraGroups = [ "libvirtd" "qemu-libvirtd" "kvm" ];
  # 对于 virtiofs，目前它在 NixOS 中的使用还没有得到很好的支持，因此我们需要在 libvirt guest 声明中为其添加一个显式选项
  environment.systemPackages = with pkgs; [ virtiofsd ];
  # 在管理器中为虚拟机增加文件系统，调好目录后修改xml部分增加二进制路径
  # <filesystem type="mount" accessmode="passthrough">
  #   <driver type="virtiofs"/>
  #   <binary path='/run/current-system/sw/bin/virtiofsd'/> # 这里是增加的
  #   <source dir="/home/evi1_f4iry/Downloads"/>
  #   <target dir="C:\linux_downloads"/>
  #   <address type="pci" domain="0x0000" bus="0x05" slot="0x00" function="0x0"/>
  # </filesystem>
  #
  networking.firewall = {
    allowedTCPPortRanges = [
      # spice
      { from = 5900; to = 5999; }
    ];
    allowedTCPPorts = [
      # libvirt
      16509
    ];
  };
  # 如果虚拟机需要使用宿主机的代理，记得在防火强中放开代理端口
}
