class Mysql
  def self.dump(server, backup = false)
    options = PREFS["databases"][server.to_s]["options"].to_mysql_options
    db = PREFS["databases"][server.to_s]["database"]
    file = const_get(server.to_s.upcase + "_DUMP_FILE")
    
    file += ".backup" if backup
    
    `mysqldump #{options} #{OPT} #{db} > #{file}`
  end
  
  def self.import(server, file = nil)
    if file.nil?
      # assume it's a hash
      file = server.keys.first # if it's :local => :remote, the file is :local
      server = server.values.first # if it's :local => :remote, the server is :remote
    end
    
    options = PREFS["databases"][server.to_s]["options"].to_mysql_options
    db = PREFS["databases"][server.to_s]["database"]
    
    if file.is_a?(Symbol)
      file = const_get(file.to_s.upcase + "_DUMP_FILE")
    end
    
    `mysql #{options} #{db} -e "SOURCE #{file}"`
  end
  
  def self.cleanup_file(file)
    other_server = nil
    
    if file.is_a?(Symbol)
      other_server = :remote if file == :local
      other_server = :local if file == :remote
      
      file = const_get(file.to_s.upcase + "_DUMP_FILE")
    end
    
    cleaned_file = File.expand_path(file + ".cleaned")
    
    # only clean it if we know what server it's going to
    if other_server
      contents = File.new(file, "r").read
      
      if other_server == :remote
        first, second = "local", "remote"
        # if remote is the server, we want to substitue all local for remote
      else
        first, second = "remote", "local"
        # if local is the server, we want to substitue all remote for local
      end
      
      PATTERNS.each do |name, pattern|
        f = pattern[first]
        r = pattern[second]
      
        f_escaped = Regexp.escape(f)
        f_regex = Regexp.new(f_escaped)
        s_regex = Regexp.new(REGEX.gsub(/:search/, f_escaped))
        difference = r.length - f.length
      
        # first, update any s: freaking strings
        contents.gsub!(s_regex) do |match|
          parts = match.scan(s_regex).first
          number = parts[0].to_i + difference
          "s:#{number}:\\\"#{r}#{parts[1]}\\\";"
        end
      
        # then just update all remaining instances of it
        contents.gsub!(f_regex, r)
      end
    end#if server
    
    # save the cleaned file
    File.open(cleaned_file, "w+") do |f|
      f.write(contents)
    end
    
    # return the cleaned file path
    cleaned_file
  end
end