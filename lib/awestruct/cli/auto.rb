#require 'guard/awestruct'

require 'listen'

module Awestruct
  module CLI
    class Auto

      def initialize(config)
        @config = config
      end

      def run()
        listener = Listen.to( @config.dir, :relative_paths=>true )
        listener.ignore( %r(\.awestruct) )
        listener.ignore( %r(^#{File.basename( @config.tmp_dir )}) )
        listener.ignore( %r(^#{File.basename( @config.output_dir )}) )
        listener.change do |modified, added, removed|
          modified.each do |path|
            engine = ::Awestruct::Engine.instance
            unless ( path =~ %r(#{File.basename( engine.config.output_dir) }) || path =~ /.awestruct/ )
              engine.generate_page_by_output_path( path )
            end
          end
        end
        listener.start( false )
      end

    end

  end
end
