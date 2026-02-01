let configDir = ./config;
in
{
    xdg.configFile."kitty".source = ./kitty;
}