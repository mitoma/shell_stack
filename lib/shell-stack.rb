require File.expand_path('../shell-stack/version', __FILE__)
require 'fileutils'
require 'yaml'

module Shell
  module Stack
    STACK_DIR = "#{ENV['HOME']}/.shell_stack"

    class Base
      def self.stacks
        Dir["#{STACK_DIR}/*.stack"].each do |stack|
          stack =~ %r[\A#{STACK_DIR}/(.+).stack\z]
          puts $1
        end
      end

      def self.delete_all
        Dir["#{STACK_DIR}/*.stack"].each do |stack|
          FileUtils.rm(stack, {:force => true})
        end
        puts "delete all stacks."
      end

      def initialize(stack_name)
        @stack_name = stack_name
        FileUtils.mkdir_p(STACK_DIR)
      end

      def path
        "#{STACK_DIR}/#{@stack_name}.stack"
      end

      def create
        FileUtils.rm(path, {:force => true})
        File.open(path, 'w') do |f|
          f.flock(File::LOCK_EX)
          f.write [].to_yaml
          f.flush
          f.flock(File::LOCK_UN)
        end
        puts "create or clear #{@stack_name}."
      end

      def count
        check_stack
        datas = YAML.load_file(path)
        puts(datas.flatten.count)
      end

      def list
        check_stack
        datas = YAML.load_file(path)
        datas.flatten.each do |value|
          puts value
        end
      end

      def push(values)
        check_stack
        File.open(path, File::RDWR|File::CREAT) do |f|
          f.flock(File::LOCK_EX)
          datas = YAML.load(f.read)
          datas = datas.flatten.push values
          f.rewind
          f.write datas.flatten.to_yaml
          f.flush
          f.truncate(f.pos)
          f.flock(File::LOCK_UN)
        end
      end

      def pop(num_of_pop = 1)
        check_stack
        result = ""
        File.open(path, File::RDWR|File::CREAT) do |f|
          f.flock(File::LOCK_EX)
          datas = YAML.load(f.read)
          result = datas.pop num_of_pop
          f.rewind
          f.write datas.to_yaml
          f.flush
          f.truncate(f.pos)
          f.flock(File::LOCK_UN)
        end
        puts Array(result).join(' ')
      end

      def check_stack
        unless File.exists?(path)
          puts "stack #{@stack_name} is not found."
          exit 1
        end
      end
    end
  end
end
