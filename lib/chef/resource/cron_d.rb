#
# Copyright:: 2018, Chef Software Inc.
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

require "chef/resource"

class Chef
  class Resource
    class CronD < Chef::Resource
      resource_name :cron_d
      provides(:cron_d) { true }

      description "Use the cron_d resource to create cron.d files."

      introduced "14.0"

      property :cron, String,
               description: "The name of the cron.d file to create.",
               name_property: true

      property :mode, [String, Integer],
               description: "The file mode of the generated file.",
               default: '0644'

      property :minute, [String, Integer],
               description: "The minute at which the cron entry should run (0 - 59).",
               default: '*'

      property :hour, [String, Integer],
               description: "iThe hour at which the cron entry is to run (0 - 23).",
               default: '*'

      property :day, [String, Integer],
               description: "The day of month at which the cron entry should run (1 - 31).",
               default: '*'

      property :month, [String, Integer],
               description: "The month in the year on which a cron entry is to run (1 - 12).",
               default: '*'

      property :weekday, [String, Integer],
               description: "The day of the week on which this entry is to run (0 - 6), where Sunday = 0.",
               default: '*'

      property :mailto, String
               description: "Set the MAILTO environment variable."

      property :path, String
               description: "Set the PATH environment variable."

      property :home, String
               description: "Set the HOME environment variable."

      property :shell, String
               description: "Set the SHELL environment variable."

      property :user, String,
               description: "The name of the user that runs the command."
               default: 'root'

      property :command, String
               description: "The command to be run, or the path to a file that contains the command to be run"

      action :create do
        description ""
        location = "/etc/cron.d/#{new_resource.cron}"

        r = with_run_context :root do
          find_resource(:template, "create cron_d file #{new_resource.cron}") do
            source "cron_d.erb"
            path location
            minute new_resource.minute
            hour new_resource.hour
            day new_resource.day
            month new_resource.month
            weekday new_resource.weekday
            mailto new_resource.mailto
            home new_resource.home
            shell new_resource.shell
            user new_resource.user
            command new_resource.command
            action :nothing
            delayed_action :create
            backup false
            variables(entries: [])
          end
        end
      end

      action :delete do
        description ""
        location = "/etc/cron.d/#{new_resource.cron}"

        file location do
          action :delete
        end
      end
    end
  end
end
