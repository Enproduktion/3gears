# Copyright (C) 2017 Enproduktion GmbH
#
# This file is part of 3gears.
#
# 3gears is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

namespace :thinking_sphinx do
  task :run_in_foreground do
    controller = ThinkingSphinx::Configuration.instance.controller

    # Workaround to make Sphinx die nicely:
    #   - PTY.spawn invokes bash -c under the covers
    #   - Which turns SIGTERM into SIGHUP (not sure exactly why, can't seem to find a reason)
    #   - Which sphinx interprets as a reload instead of a quit
    #   - So, we need to remap HUP to KILL for the purposes of this script.

    unless pid = fork
      exec "#{controller.bin_path}#{controller.searchd_binary_name} --pidfile --config #{controller.path} --nodetach"
    end

    trap("SIGHUP") { Process.kill(:TERM, pid) }
    Process.wait
  end
end
