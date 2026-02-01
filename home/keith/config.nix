let configDir = ./config;
in
{
    home.file = {
        ".config/kitty".source = "${configDir}/kitty";
    };
}