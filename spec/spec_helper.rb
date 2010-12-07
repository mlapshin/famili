require 'rubygems'
require 'active_record'

def path(path)
  File.join(File.dirname(__FILE__), path)
end

$:.unshift(path('../lib'))
require 'famili'

class TestDbUtils
  class<< self
    def config
      @config ||= {
        :database => path("/db/testdb.sqlite3"),
        :adapter => "sqlite3"
      }
    end

    #create test database
    def ensure_test_database
      connect_to_test_db
    # rescue
    #   create_database
    end

    def load_schema
      ensure_test_database
      load(path('db/schema.rb'))
    end

    def ensure_schema
      load_schema
    rescue
      puts "tests database exists: skip schema loading"
    end

    def create_database
      ActiveRecord::Base.connection.create_database(config[:database], config)
    rescue
      $stderr.puts $!, *($!.backtrace)
      $stderr.puts "Couldn't create database for #{config.inspect}"
    end

    def connect_to_test_db
      ActiveRecord::Base.establish_connection(config)
      ActiveRecord::Base.connection
    end

    def drop_database
      # connect_to_postgres_db
      # ActiveRecord::Base.connection.drop_database config[:database]
    end
  end
end
