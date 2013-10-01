local GAME_INSTALL_SIZE = 184601536
local X86_INSTALL_SIZE = 8067512
local X86_64_INSTALL_SIZE = 0
local _ = MojoSetup.translate

--  force 32bit only
local force32bit = true
local is32bit = force32bit or
        MojoSetup.cmdline("32bit") or
        MojoSetup.info.machine == "x86" or
        MojoSetup.info.machine == "i386" or
        MojoSetup.info.machine == "i586" or
        MojoSetup.info.machine == "i686"

local game_title = 'GameName'

Setup.Package
{
    vendor = "GameCompany.com",
    id = "GameName",
    description = game_title,
    version = "1.00",
--    splash = "splash.png",
    splashpos = "top",
    superuser = false,
    write_manifest = true,
    support_uninstall = true,
    recommended_destinations =
    {
        MojoSetup.info.homedir,
        "/opt/games",
        "/usr/local/games"
    },

    Setup.Readme
    {
        description = _("Readme"),
        source = _("data/README.linux")
    },

    Setup.Option
    {
        -- !!! FIXME: All this filter nonsense is because
        -- !!! FIXME:   source = "base:///some_dir_in_basepath/"
        -- !!! FIXME: doesn't work, since it wants a file when drilling
        -- !!! FIXME: for the final archive, not a directory. Fixing this
        -- !!! FIXME: properly is a little awkward, though.

        value = true,
        required = true,
        disabled = false,
        bytes = GAME_INSTALL_SIZE,
        description = game_title,

        Setup.OptionGroup
        {
            description = _("CPU Architecture"),
            Setup.Option
            {
                value = is32bit,
                required = is32bit,
                disabled = false,
                bytes = X86_INSTALL_SIZE,
                description = "x86",
                Setup.File
                {
                    wildcards = "x86/*";
                    filter = function(fn)
                        return string.gsub(fn, "^x86/", "", 1), nil
                    end
                },
                Setup.DesktopMenuItem
                {
                    disabled = false,
                    name = game_title,
                    genericname = game_title,
                    tooltip = _(game_title),
                    builtin_icon = false,
                    icon = "GameName.png",
                    commandline = "%0/GameName.bin.x86",
                    workingdir = "%0",
                    category = "Game;"
                },
            },
            Setup.Option
            {
                value = not is32bit,
                required = false,
                disabled = is32bit,
                bytes = X86_64_INSTALL_SIZE,
                description = "x86_64",
                Setup.File
                {
                    wildcards = "x86_64/*";
                    filter = function(fn)
                        return string.gsub(fn, "^x86_64/", "", 1), nil
                    end
                },
                Setup.DesktopMenuItem
                {
                    disabled = false,
                    name = game_title,
                    genericname = game_title,
                    tooltip = _(game_title),
                    builtin_icon = false,
                    icon = "GameName.png",
                    commandline = "%0/GameName.bin.x86_64",
                    workingdir = "%0",
                    category = "Game;"
                },
            },
        },

        Setup.File
        {
            wildcards = "data/*";
            filter = function(fn)
                return string.gsub(fn, "^data/", "", 1), nil
            end
        },
    }
}

-- end of config.lua ...
