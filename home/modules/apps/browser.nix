{ pkgs, ... }:

{
  home.packages = [
    pkgs.vivaldi
    pkgs.vivaldi-ffmpeg-codecs
  ];
}
