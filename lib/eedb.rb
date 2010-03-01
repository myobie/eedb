require "yaml"
require "eedb/ext"
require "eedb/mysql"

# setup our constants

TIME = Time.now.to_i

LOCAL_DUMP_FILE = File.expand_path("tmp/local-dump-#{TIME}.sql")
REMOTE_DUMP_FILE = File.expand_path("tmp/remote-dump-#{TIME}.sql")

if File.exists?("eedb.yml")
  PREFS = YAML.load_file("eedb.yml")
else
  PREFS = Hash.new(Hash.new({})) # make a fake hash that has hashes in it
end

if PREFS["opt"].empty?
  OPT = '--skip-add-locks --skip-disable-keys --skip-lock-tables --skip-set-charset --compatible="mysql40"'
else
  OPT = PREFS["opt"]
end

if PREFS["regex"].empty?
  REGEX = 's:([0-9]+):\\\\":search([a-zA-Z0-9 .+?#-_\/\\\\]*)\\\\";'
else
  REGEX = PREFS["regex"]
end

if PREFS["replace"].empty?
  PATTERNS = {}
else
  PATTERNS = PREFS["replace"]
end

class Eedb
  
  def self.rollback(which)
    backup = File.expand_path(Dir["tmp/#{which}-dump-*.sql.backup"].last)
    
    print "-   Are you sure you want to rollback the #{which} DB? (Y/n): "
    answer = STDIN.gets.chomp

    if answer == "Y"
      log "*** Rolling back #{which} using #{backup}..."
      Mysql.import(backup => which)
    end

    log "*** Done."
  end
  
  def self.export(server = :local)
    other_server = server == :local ? :remote : :local
    
    log "*** Starting dump..."

    log "*   Dumping #{server}..."
    Mysql.dump(server)

    print "-   Do you want to push this into the #{other_server} server? (Y/n): "
    answer = STDIN.gets.chomp

    if answer == "Y"
      print "-   Do you want to backup the #{other_server} DB? (Y/n): "
      answer2 = STDIN.gets.chomp

      if answer2 == "Y"
        log "*   Dumping #{other_server} as backup..."
        Mysql.dump(other_server, :backup)
      end
      
      log "**  Cleanup #{server}..."
      cleaned_file = Mysql.cleanup_file(server)
      
      log "*** Pushing #{server} cleaned file to #{other_server}..."
      Mysql.import(cleaned_file => other_server)
    end

    log "*** Done."
  end
  
  def self.import
    export(:remote)
  end
  
  def self.log(what)
    puts what
  end
  
end