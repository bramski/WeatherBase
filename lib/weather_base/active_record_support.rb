require "csv"

module WeatherBase #:nodoc:
  #The ActiveRecordSupport module of WeatherBase should be
  #included in your class which you intend to represent the WeatherBase
  #data.
  module ActiveRecordSupport
    
    def self.included(base)#:nodoc:
      base.extend(ClassMethods)
      base.serialize :high_temp_f, Array
      base.serialize :high_temp_c, Array
      base.serialize :low_temp_f, Array
      base.serialize :low_temp_c, Array
      base.serialize :days_above_85f, Array
      base.serialize :days_below_70f, Array
      base.serialize :precip_inches, Array
      base.serialize :precip_cm, Array
      base.serialize :snowfall_inches, Array
      base.serialize :snowfall_cm, Array
      base.acts_as_mappable(:units => :km)
    end

    module ClassMethods#:nodoc:

      #Loads the data in a task oriented way and returns a set of active
      #record objects which you should then save to the DB
      # == Valid Options
      # +progress+
      #  print to stdout to show ongoing progress dots and completion of sets
      def from_csv( filename, options = {})

        data_by_id = {}
        count =0

        CSV.foreach(filename) do |row|
          if ( row[0] == "Weatherbase ID" || row[1] == "City")
            next
          end
          
          count += 1
          
          if options[:progress] && (count % 1000) == 0
            print "."
          end
          
          if ! data_by_id.has_key?(row[0])
            data_by_id[row[0]] = {:weatherbase_id => row[0],
                                  :city => row[1],
                                  :state => row[2],
                                  :country => row[3],
                                  :lat => row[4],
                                  :lng => row[5],
            }
          end

          data = data_by_id[row[0]]

          case row[6]
          when "Average High Temperature"
            data[:high_temp_f] = row[8 .. 19]
            data[:high_temp_c] = row[22 .. 33]
          when "Average Low Temperature"
            data[:low_temp_f] = row[8 .. 19]
            data[:low_temp_c] = row[22 .. 33]
          when "Average Number of Days Above 85F/29C"
            data[:days_above_85f] = row[8 .. 19]
          when "Average Number of Days Below 70F/21C"
            data[:days_below_70f] = row[8 .. 19]
          when "Average Precipitation"
            data[:precip_inches] = row[8 .. 19]
            data[:precip_cm] = row[22 .. 33]
          when "Average Snowfall"
            data[:snowfall_inches] = row[8 .. 19]
            data[:snowfall_cm] = row[22 .. 33]
          end

        end

        items = []

        data_by_id.values.each do |data|
          items.push( self.new(data))
        end
        
        if options[:progress]
          puts "Done."
        end

        return items
      end
    end

    #Does this record contain snow data?
    def snow?
      return !( snowfall_inches.nil? || snowfall_cm.nil? )
    end

    #Returns an array of monthly snow data
    def snow
      snow = []
      
      if ( snowfall_inches.nil? || snowfall_cm.nil? )
        for i in ( 0 .. 11 ) do
          snow.push( Length.new( :inches => 0.0,
                                  :cm => 0.0))
        end
      else
      
        for i in ( 0 .. 11) do 
          snow.push( Length.new( :inches => snowfall_inches[i],
                                    :cm => snowfall_cm[i]) )
        end
      end

      return snow.extend(LengthMappable)
    end
    
    #Does this record contain any precipitation data?
    def precip?
      return !( precip_inches.nil? || precip_cm.nil? )
    end
    
    #Does this record contain any temperature data?
    def temperatures?
      return !( high_temp_f.nil? || low_temp_f.nil? )
    end

    #Returns a LengthMappable array of monthly precip data.
    def precip
      precips = []
      
      if ( precip_inches.nil? || precip_cm.nil? )
        for i in ( 0 .. 11 ) do
          precips.push( Length.new( :inches => 0.0,
                                    :cm => 0.0))
        end
      else
      
        for i in ( 0 .. 11 ) do
          precips.push( Length.new( :inches => precip_inches[i],
                                    :cm => precip_cm[i]) )
        end
      end

      return precips.extend(LengthMappable)
    end
    
    #Is there high temperature data with this record?
    def high?
      return !(high_temp_f.nil? || high_temp_c.nil?)
    end
    
    #Is there low temperature data with this record?
    def low?
      return !(low_temp_f.nil? || low_temp_c.nil?)
    end

    #Returns a TempMappable array of monthly high temps
    def high
      temps = []
      for i in ( 0 .. 11 ) do 
        temps.push( Temperature.new(:f => high_temp_f[i],
                                    :c => high_temp_c[i]))
      end

      return temps.extend(TempMappable)
    end

    #Returns a TempMappable array of monthly low temps
    def low
      temps = []
      for i in ( 0 .. 11 ) do 
        temps.push( Temperature.new(:f => low_temp_f[i],
                                    :c => low_temp_c[i]))
      end

      return temps.extend(TempMappable)
    end

    #TempMappable is an extension to the array class
    #which adds some helper functions for fahrenheit and celsius
    module TempMappable
      #The array of fahrenheit temps
      def f
        return self.map { |t| t.f}
      end
      
      #The array of celsius temps
      def c
        return self.map { |t| t.c}
      end
    end

    #An extension class to Array which adds inches and cm mappings
    module LengthMappable
      #The array of inches values
      def inches
        return self.map { |l| l.inches}
      end

      #The array of cm values.
      def cm
        return self.map { |l| l.cm}
      end
    end

    class Length
      attr_accessor :inches
      attr_accessor :cm

      alias :centimeters :cm
      def initialize(options)#:nodoc:
        self.inches = options[:inches]
        self.cm = options[:cm]
      end
    end

    class Temperature
      attr_accessor :f
      attr_accessor :c

      alias :fahrenheit :f
      alias :celsius :c

      def initialize(options)#:nodoc:
        self.f = options[:f]
        self.c = options[:c]
      end
    end
  end
end
