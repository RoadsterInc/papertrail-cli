module Papertrail
  module CliHelpers
    def find_configfile
      if File.exists?(path = File.expand_path('.papertrail.yml'))
        return path
      end
      if File.exists?(path = File.expand_path('~/.papertrail.yml'))
        return path
      end
    end

    def load_configfile(file_path)
      symbolize_keys(YAML.load_file(file_path))
    end

    def symbolize_keys(hash)
      new_hash = {}
      hash.each do |(key, value)|
        new_hash[(key.to_sym rescue key) || key] = value
      end

      new_hash
    end

    def set_min_max_time!(opts, q_opts)
      if opts[:min_time]
        if min_time = Chronic.parse(opts[:min_time])
          q_opts[:min_time] = min_time.to_i
          if opts[:max_time]
            if max_time = Chronic.parse(opts[:max_time])
              q_opts[:max_time] = max_time.to_i
            else
              q_opts[:max_time] = Time.now.to_i
            end
          end
        end
      end
    end

  end
end
