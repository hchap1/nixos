{ ... }:

{
  programs.mangohud = {
    enable = true;
    settings = {
      fps = true;
      frame_timing = true;
      cpu_stats = true;
      cpu_temp = true;
      gpu_stats = true;
      gpu_temp = true;
      ram = true;
      vram = true;
      position = "top-left";
    };
  };
}
