
module Dockerclean

    def Dockerclean.stopped
        docker_ps_a_regex = /(\w+)\s+([\w\-\.:]+).*?(Exited|Up)/
        output = `docker ps -a`
        output.lines.drop(1).each do |line|
            match = line.match(docker_ps_a_regex)
            if match.nil? then
                puts "Cannot parse line: #{line}"
            else
                puts `docker rm #{match[1]}` if match[3] == "Exited"
            end
        end
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

    def Dockerclean.method_missing(name)
        puts "Don't know how to clean '#{name.to_s}'.\nCan clean only 'stopped' or 'untagged'."
    end

end

Dockerclean.send(ARGV[0])

