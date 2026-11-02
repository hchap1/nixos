{ ... }:

{
  # mDNS discovery (UDP 5353) and the spiderweb data channel (TCP 12345,
  # hardcoded in src/main.rs) for the spiderweb LAN discovery/transfer tool.
  networking.firewall = {
    allowedUDPPorts = [ 5353 ];
    allowedTCPPorts = [ 12345 ];
  };
}
