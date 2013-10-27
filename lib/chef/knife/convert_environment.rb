#
# Author:: Mathieu Sauve-Frankel <msf@kisoku.net>
# Copyright:: Copyright (c) 2013 Mathieu Sauve-Frankel
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/knife'
require 'convert/environment_converter'

module JA
  class ConvertEnvironment < Chef::Knife

    banner 'knife convert environment ENVIRONMENT (options)'

    option :cookbook,
           short: '-c COOKBOOK',
           long: '--cookbook COOKBOOK',
           description: 'Cookbook name you want the environment to be added to'

    option :recipe,
           short: '-r RECIPE',
           long: '--recipe RECIPE',
           description: 'Recipe name you want the environment to be converted to',
           default: nil

    option :author,
           short: '-a Author Name',
           long: '--author Author name',
           description: 'Author name to use in the comment of the generated recipe',
           default: nil

    option :comment_enabled,
           short: '-C',
           long: '--comment_enabled',
           description: 'Enable a comment at the top of the generated recipe',
           boolean: true | false,
           default: false

    option :no_default,
           short: '-d',
           long: '--no_default',
           description: "Don't output default attributes",
           boolean: true | false,
           default: false

    option :no_override,
           short: '-o',
           long: '--no_override',
           description: "Don't output override attributes",
           boolean: true | false,
           default: false

    def run
      if @name_args.length < 1
        ui.error('You must supply the name of the environment you wish to convert')
        exit 1
      end
      env = @name_args[0]
      converter = Chef::Convert::Environment.new(env, config)
      puts converter.generate_recipe
    end
  end
end
