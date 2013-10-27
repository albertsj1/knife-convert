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

require 'erubis'
require 'chef/environment'

class Chef
  class Convert
    class Environment
      RECIPE_TEMPLATE = File.join(File.dirname(__FILE__), 'environment_converter', 'templates', 'recipe.erb')

      attr_reader :environment, :cookbook, :recipe, :comment_enabled, :author, :no_default, :no_override
      attr_accessor :attributes

      def initialize(environment, config = {})
        # Make sure :environment_path is defined and that it's not an array since Chef doesn't like passing
        # an array for this path
        env = Chef::Config[:environment_path] || './environments'
        env = env.first if env.class == 'Array' # Just in case the user has defined an array, use the first
        Chef::Config[:environment_path] = env
        @environment = Chef::Environment.load_from_file(environment)
        @config = config
        @recipe = config[:recipe] || @environment.name
        @cookbook = config[:cookbook] || 'new_cookbook'
        @author = config[:author] || 'Author name'
        @comment_enabled = config[:comment_enabled] || false
        @no_default = config[:no_default]
        @no_override = config[:no_override]
        @attributes = {
          'default' => [],
          'override' => []
        }
        @dependencies = []
      end

      def convert_environment
        convert_attributes(environment.default_attributes, 'default') unless no_default
        convert_attributes(environment.override_attributes, 'override') unless no_override
      end

      def convert_attributes(attrs, type, parents=[])
        # XXX this whole bit stinks, redo it later
        attrs.each do |attribute, value|
          # detect hashes and recursively descend to the bottommost level of nesting
          if value.is_a? Hash
            # make a copy of the parent path and add our current location before recurring
            new_parents = parents.dup
            new_parents << attribute
            convert_attributes(value, type, new_parents)
          else
            attr_path = parents.map { |a| "['#{a}']" }.join() + "['#{attribute}']"
            attributes[type].push("node.#{type}#{attr_path} = #{value.pretty_inspect}")
          end
        end
      end

      def generate_recipe
        convert_environment
        template = IO.read(Chef::Convert::Environment::RECIPE_TEMPLATE).chomp
        eruby = Erubis::Eruby.new(template)
        context = {
          :cookbook => cookbook,
          :recipe => recipe,
          :default_attributes => attributes['default'],
          :override_attributes => attributes['override'],
          :comment_enabled => comment_enabled,
          :author => author
        }
        eruby.evaluate(context)
      end
    end
  end
end
