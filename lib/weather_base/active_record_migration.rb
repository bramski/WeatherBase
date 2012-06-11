module WeatherBase #:nodoc:
  #The ActiveRecordMigration class is used as a mixin for your
  #Migration to create the necessary fields to use the WeatherBase
  #ActiveRecordSupport module.  See the populate_table method.
  module ActiveRecordMigration
    
    def self.included(base) #:nodoc:
      base.extend(ClassMethods)
    end
    
    module ClassMethods #:nodoc:
      #Populates the given table with all the fields
      #required for use of the ActiveRecordSupport class.
      def populate_table(t)
        t.integer :id
        t.integer :weatherbase_id, :unique => true, :nullable => false
        t.string :city
        t.string :state
        t.string :country
        t.float :lat, :nullable => false
        t.float :lng, :nullable => false
        t.string :high_temp_f
        t.string :high_temp_c
        t.string :low_temp_f
        t.string :low_temp_c
        t.string :days_above_85f
        t.string :days_below_70f
        t.string :precip_inches
        t.string :precip_cm
        t.string :snowfall_inches
        t.string :snowfall_cm
      end
    end
  end
end
