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
      FileUtils.rm(path)
      File.open(path, 'w') do |f|
        f.write []
      end
    end

    def self.push(stack_name, values)
      init
      path = "#{STACK_DIR}/#{stack_name}.stack"
      datas = YAML.load_file(path)
      datas = datas.flatten.push values
      File.open(path, 'w') do |f|
        f.write datas.flatten.to_yaml
      end
    end

    def self.pop(stack_name, num_of_pop = 1)
      path = "#{STACK_DIR}/#{stack_name}.stack"
      datas = YAML.load_file(path)
      result = datas.pop num_of_pop
      File.open(path, 'w') do |f|
        f.write datas.to_yaml
      end
      result
    end
  end
end
