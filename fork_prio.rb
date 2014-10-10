#! /usr/local/bin/ruby

fork do
  Process.setpriority(Process::PRIO_PROCESS, 0, 19)
  sleep
end
