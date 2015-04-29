#!/usr/bin/env ruby

module Dockerclean

    def Dockerclean.all
        Dockerclean.stopped
        Dockerclean.untagged
    end

    def Dockerclean.stopped
        `docker rm $(docker ps -a -q)`
    end

    def Dockerclean.untagged
        docker_iamges_regex = /(<none>|\S+)\s+(<none>|\S+)\s+(\w+)/
        output = `docker images`
        output.lines.drop(1).each do |line|
            match = line.match(docker_iamges_regex)
            if match.nil? then
                puts "Cannot parse line: #{line}"
            else
                puts `docker rmi #{match[3]}` if match[1] == "<none>"
            end
        end
    end

    def Dockerclean.help
        puts <<EOH
Usage:
    dockerclean <command>

List of available commands:
    - stopped  : calls 'docker rm' on each container in stopped status
    - untagged : calls 'docker rmi' on each image that has no assigned name
    - help     : shows this text
EOH
    end

    def Dockerclean.method_missing(name)
        puts "Don't know how to clean '#{name.to_s}'.\nCan clean only 'stopped' or 'untagged'.\nUse 'dockerclean help' for more info.'"
    end

end

Dockerclean.send(ARGV[0] || :help)

