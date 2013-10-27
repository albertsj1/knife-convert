# Knife Convert

# DESCRIPTION:

knife-convert helps convert existing roles and environments into recipes to be placed into role and environment cookbooks.

Note: This code was originally forked from [knife-role-convert](https://github.com/kisoku/knife-role-convert). I added the ability to convert an envionrment in addition to a role.  This additional functionality required a need to change the plugin name, as knife-role-convert didn't make sense for a plugin that also converts environment files. :)

# INSTALLATION:
This plugin can be installed as a Ruby Gem.

    gem install knife-convert

You can also copy the source repository and install it using +rake install+.

# USAGE:

## knife convert role

knife convert take a single role and spits an equivalent recipe to stdout.

    knife convert role ROLE (options)
        -r, --recipe RECIPE              Recipe name you want the role to be ceonverted to
        -C, --comment_enabled            Enable a comment at the top of the generated recipe
        -c, --cookbook COOKBOOK          Cookbook name you want the role to be added to
        -d, --no_default                 Don't output default attributes
        -o, --no_override                Don't output override attributes
        -R, --no_runlist                 Don't output runlist lines



## knife convert environment

knife convert takes a single environment and spits an equivalent recipe to stdout.

    knife convert environment ENVIRONMENT (options)
        -a, --author Author name         Author name to use in the comment of the generated recipe
        -C, --comment_enabled            Enable a comment at the top of the generated recipe
        -c, --cookbook COOKBOOK          Cookbook name you want the environment to be added to
        -E, --environment ENVIRONMENT    Set the Chef environment
        -d, --no_default                 Don't output default attributes
        -o, --no_override                Don't output override attributes
        -r, --recipe RECIPE              Recipe name you want the environment to be converted to
