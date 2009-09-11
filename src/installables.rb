
require 'open-uri'

module JSpec
  class Installable
    
    ##
    # Options array
    
    attr_reader :options
    
    ##
    # Initialize with _options_
    
    def initialize options = {}
      @options = options
    end
    
    ##
    # Called before installing.
    
    def before; end
    
    ##
    # Called after installing.
    
    def after; end
    
    ##
    # Message to display after installation.
    
    def install_message; end
    
    ##
    # Weither or not to use the progress bar.
    
    def use_progress_bar?; true end
    
    #--
    # Rhino
    #++
    
    class Rhino < self
      
      ##
      # No thanks!
      
      def use_progress_bar?
        false
      end
      
      ##
      # Zip uri.
      
      def uri
        'ftp://ftp.mozilla.org/pub/mozilla.org/js/rhino1_7R2.zip'
      end
      
      ##
      # Extension destination.
      
      def dest
        '/Library/Java/Extensions/js.jar'
      end
      
      ##
      # Install
      
      def install
        say "... downloading #{uri}"; `curl #{uri} -o /tmp/rhino.zip`
        say "... decompressing"; `unzip /tmp/rhino.zip -d /tmp`
        say "... installing to #{dest}"; `sudo mv /tmp/rhino1_7R2/js.jar #{dest}`
      end
      
      ##
      # Install message.
      
      def install_message
        "Rhino installed:\n" \
        "Usage: java org.mozilla.javascript.tools.shell.Main [options...] [files]"
      end
      
    end
    
    #--
    # Google lib
    #++
    
    class GoogleLib < self

      ##
      # Release specified or the current release.
      
      def release
        options[:release] || self.class.current
      end
      
      ##
      # Installation path.
      
      def path
        options[:to] + "/#{self.class.name.downcase.tr(' ', '.')}.js"
      end
      
      ##
      # Installation uri.
      
      def uri
        self.class.uri.sub 'RELEASE', release
      end
      
      ##
      # Install.
      
      def install
        File.open(path, 'w+') do |file|
          file.write open(uri).read
        end
      end
      
      ##
      # Installation message.
      
      def install_message
        "#{self.class.name} #{release} installed to #{path}"
      end
      
      #--
      # DSL
      #++
      
      class << self
        attr_accessor :name, :uri, :current
      end

    end
    
    #--
    # jQuery
    #++
    
    class Jquery < GoogleLib
      @name = 'jQuery'
      @current = '1.3.2'
      @uri = 'http://ajax.googleapis.com/ajax/libs/jquery/RELEASE/jquery.js'
    end
    
    #--
    # jQuery UI.
    #++
    
    class Jqueryui < GoogleLib
      @name = 'jQuery UI'
      @current = '1.7.2'
      @uri = 'http://ajax.googleapis.com/ajax/libs/jqueryui/RELEASE/jquery-ui.js'
    end
    
    #--
    # Prototype
    #++
    
    class Prototype < GoogleLib
      @name = 'Prototype'
      @current = '1.6.1.0'
      @uri = 'http://ajax.googleapis.com/ajax/libs/prototype/RELEASE/prototype.js'
    end
    
    #--
    # MooTools
    #++
    
    class Mootools < GoogleLib
      @name = 'MooTools'
      @current = '1.2.3'
      @uri = 'http://ajax.googleapis.com/ajax/libs/mootools/RELEASE/mootools.js'
    end
    
    #--
    # Dojo
    #++
    
    class Dojo < GoogleLib
      @name = 'Dojo'
      @current = '1.3.2'
      @uri = 'http://ajax.googleapis.com/ajax/libs/dojo/RELEASE/dojo/dojo.xd.js.uncompressed.js'
    end
    
  end
end