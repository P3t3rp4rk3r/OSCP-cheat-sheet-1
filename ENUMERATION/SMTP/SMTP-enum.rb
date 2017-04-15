#!/usr/bin/ruby
# requires gem concurrent & concurrent-edge
# smtp-enum.rb -x VRFY,EXPN -t 192.168.90.143 -U "/root/users.txt" -p 25,114
# smtp-enum.rb -H "/root/hosts.txt" -u root
# smtp-enum.rb -v -x VRFY,EXPN -H hosts.txt -U users.txt -p 25,114,139,200
# smtp-enum.rb -H hosts.txt -U users.txt -o output.tx

require 'optparse'
require 'socket'
require 'concurrent'
require 'concurrent-edge'
require 'timeout'

options = {:host => nil, :hosts => nil, :cmds => nil, :ports => nil, :user => nil, :users => nil, :output => nil}
summary = ""

ARGV.push("-h") if ARGV.empty?
parser = OptionParser.new do|opts|
  opts.banner="[+] Usage: smtp-enum.rb [options]\n[+] Ex: smtp-enum.rb -t 192.168.190.40 -U users.txt"
  opts.on("-t","--host ip", "target ip address"){|ip| options[:host] = ip }
  opts.on("-H","--Hosts ips", "file of target ip addresses"){|ips| options[:hosts] = ips }
  opts.on("-x","--cmd x,y", Array, "comma seperated list of smtp commands VRFY,EXPN - default VRFY"){|cmd| options[:cmds] = cmd }
  opts.on("-p","--ports x,y",Array, "port or ports to scan comma seperated - default 25"){|port| options[:ports] = port }
  opts.on("-u","--user username", "try one user"){|user| options[:user] = user }
  opts.on("-U","--users usernames", "file of usernames"){|users| options[:users] = users }
  opts.on("-v","--verbose", "display all output"){|v| options[:verbose] = v }
  opts.on("-o","--output output", "save output to file location"){|output| options[:output] = output }
  opts.on("-h","--help", "displays Help") do
    puts opts
    exit
  end
  summary = opts.summarize
end.parse!

@output  = options[:output]
@host    = options[:host]
@hosts   = options[:hosts]
@cmds    = options[:cmds]  || ['VRFY']
@ports   = options[:ports] || [25]
@user    = options[:user]
@users   = options[:users]
@verbose = options[:verbose]
@strings = []
@results = []

def save_file(data)
  File.open("#{@output}","a"){|f|f.write(data)}
end

def threading(host,port)
  pool = Concurrent::FixedThreadPool.new(10)
  begin
    host = host.to_s.chomp
    status = Timeout::timeout(5) { TCPSocket.new(host, port) }
    if @users
      File.foreach("#{@users}") do |user|
        pool.post do
          @cmds.each{|cmd|
            user.to_s if user
            client = TCPSocket.new("#{host}", port)
            client.write("#{cmd} #{user.chomp}\r\n")
            client.close_write
            @results << client.read
          }
        end
      end
      pool.shutdown
      pool.wait_for_termination
    elsif @user
      pool.post do
        @cmds.each{|cmd|
          client = TCPSocket.new("#{host}", port)
          client.write("#{cmd} #{@user}\r\n")
          client.close_write
          @results << client.read
        }
      end
      pool.shutdown
      pool.wait_for_termination
    else
      puts "[@] Err: must provide 1 user (-u ultralaser) or 1 file of newline delimitted users (-U doctordoom.txt)"
      exit(1)
    end
    puts "[+] #{host}:#{port} -- SUCCEEDED"
  rescue => ex
    puts "[+] #{host}:#{port} -- FAILED"
    #{ex.class}: #{ex.message}"
  end
end

def request()
  puts "\n=============== HOSTS ===============\n\n"
  @ports.each{|port|
    if @host
      threading(@host,port)
    elsif @hosts
      File.readlines("#{@hosts}").each do |host|
        threading(host,port)
      end
    end
  } if @ports
end

def format_output()
  banner = "\n============== RESULTS ==============\n\n"
  output = banner
  @results.each do |result|
    if result.include?('252 ') || result.include?('250 ')
      output += "[+] #{result.chomp} exists\n"
    end unless @verbose
    if @verbose
      output += @results.join("\r\n[+]")
    end
  end
  if @output
    save_file(output)
  end
  puts output
end

request
format_output
