require File.expand_path('../shell-stack/version',__FILE__)
require 'fileutils'
require 'yaml'

module Shell
  module Stack
    STACK_DIR = "#{ENV['HOME']}/.shell_stack"
    def self.init
      FileUtils.mkdir_p(STACK_DIR)
    end

    def self.create(stack_name)
      init
      path = "#{STACK_DIR}/#{stack_name}.stack"
      FileUtils.rm(path, {:force => true})
      File.open(path, 'w') do |f|
        f.flock(File::LOCK_EX)
        f.write [].to_yaml
        f.flock(File::LOCK_UN)
      end
      puts "#{stack_name} created."
    end

    def self.count(stack_name)
      init
      path = "#{STACK_DIR}/#{stack_name}.stack"
      datas = YAML.load_file(path)
      puts(datas.flatten.count)
    end

    def self.list(stack_name)
      init
      path = "#{STACK_DIR}/#{stack_name}.stack"
      datas = YAML.load_file(path)
      datas.flatten.each do |value|
        puts value
      end
    end

    def self.push(stack_name, values)
      init
      path = "#{STACK_DIR}/#{stack_name}.stack"
      datas = YAML.load_file(path)
      datas = datas.flatten.push values
      File.open(path, 'w') do |f|
        f.flock(File::LOCK_EX)
        f.write datas.flatten.to_yaml
        f.flock(File::LOCK_UN)
      end
    end

    def self.pop(stack_name, num_of_pop = 1)
      path = "#{STACK_DIR}/#{stack_name}.stack"
      datas = YAML.load_file(path)
      result = datas.pop num_of_pop
      File.open(path, 'w') do |f|
        f.flock(File::LOCK_EX)
        f.write datas.to_yaml
        f.flock(File::LOCK_UN)
      end
      puts Array(result).join(' ')
    end
  end
end
