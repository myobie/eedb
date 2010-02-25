require "yaml"
require "eedb/ext"
require "eedb/mysql"

# setup our constants

TIME = Time.now.to_i

LOCAL_DUMP_FILE = File.expand_path("tmp/local-dump-#{TIME}.sql")
REMOTE_DUMP_FILE = File.expand_path("tmp/remote-dump-#{TIME}.sql")

PREFS = YAML.load_file("eedb.yml")

if PREFS["opt"].empty?
  OPT = '--skip-add-locks --skip-create-options --skip-disable-keys --skip-lock-tables --skip-set-charset --compatible="mysql40"'
else
  OPT = PREFS["opt"]
end

if PREFS["regex"].empty?
  REGEX = 's:([0-9]+):\\\\":search([a-zA-Z0-9 .+?#-_\/\\\\]*)\\\\";'
else
  REGEX = PREFS["regex"]
end

if PREFS["patterns"].empty?
  PATTERNS = {}
else
  PATTERNS = PREFS["replace"]
end

class Eedb
  
  def self.rollback(which = :remote)
    backup = File.expand_path(Dir["tmp/#{which}-dump-*.sql.backup"].last)
    
    print "-   Are you sure you want to rollback the #{which} DB? (Y/n): "
    answer = gets.chomp

    if answer == "Y"
      log "*** Rolling back #{which} using #{backup}..."
      Mysql.import(backup => which)
    end

    log "*** Done."
  end
  
  def self.export
    log "*** Starting export..."

    print "-   Do you want to backup the remote DB? (Y/n): "
    answer = gets.chomp

    if answer == "Y"
      log "*   Dumping remote as backup..."
      Mysql.dump(:remote, :backup)
    end

    log "*   Dumping local..."
    Mysql.dump(:local)

    print "-   Do you want to push the export to the remote server? (Y/n): "
    answer = gets.chomp

    if answer == "Y"
      log "**  Cleanup local..."
      cleaned_file = Mysql.cleanup_file(:local)
      
      log "*** Pushing local cleaned file to remote..."
      Mysql.import(cleaned_file => :remote)
    end

    log "*** Done."
  end
  
  def self.import
    log "*** Starting impor..."
    
    print "-   Do you want to backup the local DB? (Y/n): "
    answer = gets.chomp
    
    if answer == "Y"
      log "*   Dumping local as backup..."
      Mysql.dump(:local, :backup)
    end
    
    log "*   Dumping remote..."
    Mysql.dump(:remote)

    print "-   Do you want to pull the export into the local server? (Y/n): "
    answer = gets.chomp

    if answer == "Y"
      log "**  Cleanup remote..."
      cleaned_file = Mysql.cleanup_file(:remote)
      
      log "*** Pushing local cleaned file to remote..."
      Mysql.import(cleaned_file => :local)
    end

    log "*** Done."
  end
  
  def self.log(what)
    puts what
  end
  
end